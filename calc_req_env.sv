class calc_req_env extends uvm_env;

   calc_rst_agent m_rst_agent;
   calc_req_agent m_req_agent[4];
   calc_req_scbd m_req_scbd; 
   
   `uvm_component_utils(calc_req_env)
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
   extern virtual function void build_phase (uvm_phase phase);
   extern virtual function void connect_phase (uvm_phase phase);
   
endclass : calc_req_env

function void calc_req_env::build_phase(uvm_phase phase);
   super.build_phase(phase);
   m_rst_agent = calc_rst_agent::type_id::create("m_rst_agent",  this);
   m_req_scbd = calc_req_scbd::type_id::create("m_req_scbd", this);

   for (int i = 0; i < 4; i++)begin
      m_req_agent[i] = calc_req_agent::type_id::create($sformatf("m_req_agent%0d", i), this);
   end
   `uvm_info(get_type_name(), "Agent build", UVM_LOW)
endfunction : build_phase

function void calc_req_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   `uvm_info(get_type_name(), "Environment connected", UVM_LOW)
   
   m_req_agent[0].m_req_monitor.item_collected_port_o.connect(m_req_scbd.scbd_port_o_0);
   m_req_agent[1].m_req_monitor.item_collected_port_o.connect(m_req_scbd.scbd_port_o_1);
   m_req_agent[2].m_req_monitor.item_collected_port_o.connect(m_req_scbd.scbd_port_o_2);
   m_req_agent[3].m_req_monitor.item_collected_port_o.connect(m_req_scbd.scbd_port_o_3);
   m_req_agent[0].m_req_monitor.item_collected_port_i.connect(m_req_scbd.scbd_port_i_0);
   m_req_agent[1].m_req_monitor.item_collected_port_i.connect(m_req_scbd.scbd_port_i_1);
   m_req_agent[2].m_req_monitor.item_collected_port_i.connect(m_req_scbd.scbd_port_i_2);
   m_req_agent[3].m_req_monitor.item_collected_port_i.connect(m_req_scbd.scbd_port_i_3); 
   
endfunction : connect_phase