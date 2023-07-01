class calc_tb_env extends uvm_env;
   
   calc_tb_vseqr m_tb_vseqr;
   calc_req_env m_req_env;
   calc_reg_env m_reg_env;
   
   virtual Reset_if rst_if;
   virtual Clock_if clk_if;
   
   `uvm_component_utils(calc_tb_env)
   
   function new(input string name, input uvm_component parent = null);
      super.new(name, parent);
   endfunction : new
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   
endclass : calc_tb_env

function void calc_tb_env::build_phase(uvm_phase phase);
   super.build_phase(phase);
   m_tb_vseqr = calc_tb_vseqr::type_id::create("m_tb_vseqr", this);
   m_req_env = calc_req_env::type_id::create("m_req_env", this);
   m_reg_env = calc_reg_env::type_id::create("m_reg_env", this);
   
   `uvm_info(get_type_name(), "Environment build", UVM_LOW)
endfunction : build_phase

function void calc_tb_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);

   m_tb_vseqr.m_rst_seqr = m_req_env.m_rst_agent.m_rst_seqr;
   for (int i = 0; i < 4; i++)begin // FIXME: should not have hardcoded 4
      m_tb_vseqr.m_req_seqr[i] = m_req_env.m_req_agent[i].m_req_seqr;
   end

   if(!uvm_config_db#(virtual Reset_if)::get(this, get_full_name(), "rst_if", rst_if))
      `uvm_error(this.get_type_name(), {"rst_if not found in config_db"})
   if(!uvm_config_db#(virtual Clock_if)::get(this, get_full_name(), "clk_if", clk_if))
      `uvm_error(this.get_type_name(), {"clk_if not found in config_db"})
      
   m_reg_env.m_reg_model.reg_map0.set_sequencer(m_tb_vseqr.m_req_seqr[0], m_reg_env.m_reg_adapter[0]);
   m_reg_env.m_reg_model.reg_map1.set_sequencer(m_tb_vseqr.m_req_seqr[1], m_reg_env.m_reg_adapter[1]);
   m_reg_env.m_reg_model.reg_map2.set_sequencer(m_tb_vseqr.m_req_seqr[2], m_reg_env.m_reg_adapter[2]);
   m_reg_env.m_reg_model.reg_map3.set_sequencer(m_tb_vseqr.m_req_seqr[3], m_reg_env.m_reg_adapter[3]);
   m_req_env.m_req_agent[0].m_req_monitor.item_collected_port_i.connect(m_reg_env.m_reg_predictor[0].bus_in);
   m_req_env.m_req_agent[1].m_req_monitor.item_collected_port_i.connect(m_reg_env.m_reg_predictor[1].bus_in);
   m_req_env.m_req_agent[2].m_req_monitor.item_collected_port_i.connect(m_reg_env.m_reg_predictor[2].bus_in);
   m_req_env.m_req_agent[3].m_req_monitor.item_collected_port_i.connect(m_reg_env.m_reg_predictor[3].bus_in);
    
endfunction : connect_phase

task calc_tb_env::run_phase(uvm_phase phase);
   fork
      forever begin
	      @(negedge clk_if.clk);
         super.run_phase(phase);
      end
      forever begin
         wait(rst_if.rst == 1);
         `uvm_info(get_full_name(), "Resetting reg_model", UVM_LOW)
         m_reg_env.m_reg_model.reset();
         @(negedge clk_if.clk);
      end
   join
endtask