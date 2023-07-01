class calc_tb_vseqr extends uvm_sequencer;
   `uvm_component_utils(calc_tb_vseqr)
   
   calc_req_seqr m_req_seqr[4];
   calc_rst_seqr m_rst_seqr;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

endclass : calc_tb_vseqr