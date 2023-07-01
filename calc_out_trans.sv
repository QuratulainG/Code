class calc_out_trans extends uvm_sequence_item;

   bit [0:31] data_o;
   bit [0:1] resp_o;
   bit [0:1] tag_o;
	
   `uvm_object_utils_begin(calc_out_trans)
      `uvm_field_int(data_o, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(resp_o, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(tag_o, UVM_DEFAULT|UVM_DEC)
   `uvm_object_utils_end
	
   function new(string name = "calc_out_trans");
      super.new(name);
   endfunction : new
   
endclass : calc_out_trans