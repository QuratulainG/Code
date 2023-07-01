class calc_rst_seqr extends uvm_sequencer #(calc_rst_trans);
   
  `uvm_component_utils(calc_rst_seqr)
    
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
endclass : calc_rst_seqr