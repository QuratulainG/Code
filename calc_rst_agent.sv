class calc_rst_agent extends uvm_agent;

   calc_rst_seqr m_rst_seqr;
   calc_rst_driver m_rst_driver;
   
   `uvm_component_utils_begin(calc_rst_agent)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
   `uvm_component_utils_end
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

endclass : calc_rst_agent

function void calc_rst_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(is_active == UVM_ACTIVE) begin
      m_rst_seqr = calc_rst_seqr::type_id::create("m_rst_seqr", this);
      m_rst_driver = calc_rst_driver::type_id::create("m_rst_driver", this);
   end
endfunction : build_phase

function void calc_rst_agent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   if(is_active == UVM_ACTIVE) begin
      m_rst_driver.seq_item_port.connect(m_rst_seqr.seq_item_export);
   end
endfunction : connect_phase



