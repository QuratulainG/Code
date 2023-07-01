class calc_seq_reset extends uvm_sequence #(calc_rst_trans);
   
   int count;
  
   `uvm_object_utils(calc_seq_reset)
   
   function new(string name = "calc_seq_reset");
      super.new(name);
   endfunction : new
 
   virtual task body();
      calc_rst_trans req;

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
    
      req = calc_rst_trans::type_id::create("req");
      req.rst = 1;
      req.clk_cycles = count;
      req.print();

      start_item(req);
      finish_item(req);
      get_response(req);

   endtask : body
   
endclass : calc_seq_reset


