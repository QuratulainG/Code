class calc_req_trans extends uvm_sequence_item;

   rand bit [0:31] data_i; 
   rand bit [0:3] cmd_i;
   rand bit [0:3] d1_i; // reg # of operand1
   rand bit [0:3] d2_i; // reg # of operand2 
   rand bit [0:3] r1_i; // reg # where data is to be fetched or stored
   bit [0:1] tag_i;
   
   constraint valid_cmd {cmd_i inside {1,2,5,6,9,10,12,13};}

   `uvm_object_utils_begin(calc_req_trans)
      `uvm_field_int(data_i, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(cmd_i, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(d1_i, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(d2_i, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(r1_i, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(tag_i, UVM_DEFAULT|UVM_DEC)
   `uvm_object_utils_end
	
   function new(string name = "calc_req_trans");
      super.new(name);
   endfunction : new
   
endclass : calc_req_trans