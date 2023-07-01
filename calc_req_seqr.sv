class calc_req_seqr extends uvm_sequencer #(calc_req_trans);
   
   `uvm_component_utils(calc_req_seqr)
    
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
endclass : calc_req_seqr