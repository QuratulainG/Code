class calc_req_agent extends uvm_agent;

   calc_req_monitor m_req_monitor;
   calc_req_seqr m_req_seqr;
   calc_req_driver m_req_driver;
   
   `uvm_component_utils_begin(calc_req_agent)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
   `uvm_component_utils_end
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

endclass : calc_req_agent

function void calc_req_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   m_req_monitor = calc_req_monitor::type_id::create("m_req_monitor", this);
   if(is_active == UVM_ACTIVE) begin
      m_req_seqr = calc_req_seqr::type_id::create("m_req_seqr", this);
      m_req_driver = calc_req_driver::type_id::create("m_req_driver", this);
   end
endfunction : build_phase

function void calc_req_agent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   m_req_monitor.item_collected_port_o.connect(m_req_driver.mon_drv_port_o);
   if(is_active == UVM_ACTIVE) begin
      m_req_driver.seq_item_port.connect(m_req_seqr.seq_item_export);
   end
endfunction : connect_phase
