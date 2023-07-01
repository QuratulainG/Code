class calc_reg extends uvm_reg;
	
	uvm_reg_field data;
	
	`uvm_object_utils(calc_reg)	

	function new(input string name = "calc_reg");
		super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
	endfunction : new
	
	virtual function void build();
		data = uvm_reg_field::type_id::create("data");
		data.configure(this, 32, 0, "RW", 0, 0, 1, 1, 1);
	endfunction : build
	
endclass : calc_reg