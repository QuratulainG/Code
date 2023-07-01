class calc_rst_trans extends uvm_sequence_item;

   bit rst;
   int clk_cycles;
   
   `uvm_object_utils_begin(calc_rst_trans)
      `uvm_field_int(rst, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(clk_cycles, UVM_DEFAULT|UVM_DEC)
   `uvm_object_utils_end
   
   function new(string name = "calc_rst_trans");
      super.new(name);
   endfunction : new

endclass : calc_rst_trans