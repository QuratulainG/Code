class calc_reg_model extends uvm_reg_block;
	
   calc_reg reg_0;
   calc_reg reg_1;
   calc_reg reg_2;
   calc_reg reg_3;
   calc_reg reg_4;
   calc_reg reg_5;
   calc_reg reg_6;
   calc_reg reg_7;
   calc_reg reg_8;
   calc_reg reg_9;
   calc_reg reg_10;
   calc_reg reg_11;
   calc_reg reg_12;
   calc_reg reg_13;
   calc_reg reg_14;
   calc_reg reg_15;
   uvm_reg_map reg_map0, reg_map1, reg_map2, reg_map3;
	
   `uvm_object_utils(calc_reg_model)
	
   function new(input string name = "m_reg_model");
      super.new(name, UVM_NO_COVERAGE);	
   endfunction : new
	
   virtual function void build();   
	  
     reg_0 = calc_reg::type_id::create("reg_0");
	 reg_1 = calc_reg::type_id::create("reg_1");
	 reg_2 = calc_reg::type_id::create("reg_2");
	 reg_3 = calc_reg::type_id::create("reg_3");
	 reg_4 = calc_reg::type_id::create("reg_4");
	 reg_5 = calc_reg::type_id::create("reg_5");
	 reg_6 = calc_reg::type_id::create("reg_6");
	 reg_7 = calc_reg::type_id::create("reg_7");
	 reg_8 = calc_reg::type_id::create("reg_8");
	 reg_9 = calc_reg::type_id::create("reg_9");
	 reg_10 = calc_reg::type_id::create("reg_10");
	 reg_11 = calc_reg::type_id::create("reg_11");
	 reg_12 = calc_reg::type_id::create("reg_12");
	 reg_13 = calc_reg::type_id::create("reg_13");
	 reg_14 = calc_reg::type_id::create("reg_14");
	 reg_15 = calc_reg::type_id::create("reg_15");
	  
	 reg_0.configure(this, null, "reg0");
	 reg_1.configure(this, null, "reg1");
	 reg_2.configure(this, null, "reg2");
	 reg_3.configure(this, null, "reg3");
	 reg_4.configure(this, null, "reg4");
	 reg_5.configure(this, null, "reg5");
	 reg_6.configure(this, null, "reg6");
	 reg_7.configure(this, null, "reg7");
	 reg_8.configure(this, null, "reg8");
	 reg_9.configure(this, null, "reg9");
	 reg_10.configure(this, null, "reg10");
	 reg_11.configure(this, null, "reg11");
	 reg_12.configure(this, null, "reg12");
	 reg_13.configure(this, null, "reg13");
	 reg_14.configure(this, null, "reg14");
	 reg_15.configure(this, null, "reg15");
	 
	 reg_0.build();
	 reg_1.build();
	 reg_2.build();
	 reg_3.build();
	 reg_4.build();
	 reg_5.build();
	 reg_6.build();
	 reg_7.build();
	 reg_8.build();
	 reg_9.build();
	 reg_10.build();
	 reg_11.build();
	 reg_12.build();
	 reg_13.build();
	 reg_14.build();
	 reg_15.build();
	 
	 reg_map0 = create_map("reg_map0", 0, 4, UVM_LITTLE_ENDIAN, 0);
	   
	 reg_map0.add_reg(reg_0, 'd0, "RW");
	 reg_map0.add_reg(reg_1, 'd1, "RW");
	 reg_map0.add_reg(reg_2, 'd2, "RW");
	 reg_map0.add_reg(reg_3, 'd3, "RW");
	 reg_map0.add_reg(reg_4, 'd4, "RW");
	 reg_map0.add_reg(reg_5, 'd5, "RW");
	 reg_map0.add_reg(reg_6, 'd6, "RW");
	 reg_map0.add_reg(reg_7, 'd7, "RW");
	 reg_map0.add_reg(reg_8, 'd8, "RW");
	 reg_map0.add_reg(reg_9, 'd9, "RW");
	 reg_map0.add_reg(reg_10, 'd10, "RW");
	 reg_map0.add_reg(reg_11, 'd11, "RW");
	 reg_map0.add_reg(reg_12, 'd12, "RW");
	 reg_map0.add_reg(reg_13, 'd13, "RW");
	 reg_map0.add_reg(reg_14, 'd14, "RW");
	 reg_map0.add_reg(reg_15, 'd15, "RW"); 
	  
	 reg_map1 = create_map("reg_map1", 0, 4, UVM_LITTLE_ENDIAN, 0);
	   
	 reg_map1.add_reg(reg_0, 'd0, "RW");
	 reg_map1.add_reg(reg_1, 'd1, "RW");
	 reg_map1.add_reg(reg_2, 'd2, "RW");
	 reg_map1.add_reg(reg_3, 'd3, "RW");
	 reg_map1.add_reg(reg_4, 'd4, "RW");
	 reg_map1.add_reg(reg_5, 'd5, "RW");
	 reg_map1.add_reg(reg_6, 'd6, "RW");
	 reg_map1.add_reg(reg_7, 'd7, "RW");
	 reg_map1.add_reg(reg_8, 'd8, "RW");
	 reg_map1.add_reg(reg_9, 'd9, "RW");
	 reg_map1.add_reg(reg_10, 'd10, "RW");
	 reg_map1.add_reg(reg_11, 'd11, "RW");
	 reg_map1.add_reg(reg_12, 'd12, "RW");
	 reg_map1.add_reg(reg_13, 'd13, "RW");
	 reg_map1.add_reg(reg_14, 'd14, "RW");
	 reg_map1.add_reg(reg_15, 'd15, "RW");

     reg_map2 = create_map("reg_map2", 0, 4, UVM_LITTLE_ENDIAN, 0);
	   
	 reg_map2.add_reg(reg_0, 'd0, "RW");
	 reg_map2.add_reg(reg_1, 'd1, "RW");
	 reg_map2.add_reg(reg_2, 'd2, "RW");
	 reg_map2.add_reg(reg_3, 'd3, "RW");
	 reg_map2.add_reg(reg_4, 'd4, "RW");
	 reg_map2.add_reg(reg_5, 'd5, "RW");
	 reg_map2.add_reg(reg_6, 'd6, "RW");
	 reg_map2.add_reg(reg_7, 'd7, "RW");
	 reg_map2.add_reg(reg_8, 'd8, "RW");
	 reg_map2.add_reg(reg_9, 'd9, "RW");
	 reg_map2.add_reg(reg_10, 'd10, "RW");
	 reg_map2.add_reg(reg_11, 'd11, "RW");
	 reg_map2.add_reg(reg_12, 'd12, "RW");
	 reg_map2.add_reg(reg_13, 'd13, "RW");
	 reg_map2.add_reg(reg_14, 'd14, "RW");
	 reg_map2.add_reg(reg_15, 'd15, "RW");	

     reg_map3 = create_map("reg_map3", 0, 4, UVM_LITTLE_ENDIAN, 0);
	   
	 reg_map3.add_reg(reg_0, 'd0, "RW");
	 reg_map3.add_reg(reg_1, 'd1, "RW");
	 reg_map3.add_reg(reg_2, 'd2, "RW");
	 reg_map3.add_reg(reg_3, 'd3, "RW");
	 reg_map3.add_reg(reg_4, 'd4, "RW");
	 reg_map3.add_reg(reg_5, 'd5, "RW");
	 reg_map3.add_reg(reg_6, 'd6, "RW");
	 reg_map3.add_reg(reg_7, 'd7, "RW");
	 reg_map3.add_reg(reg_8, 'd8, "RW");
	 reg_map3.add_reg(reg_9, 'd9, "RW");
	 reg_map3.add_reg(reg_10, 'd10, "RW");
	 reg_map3.add_reg(reg_11, 'd11, "RW");
	 reg_map3.add_reg(reg_12, 'd12, "RW");
	 reg_map3.add_reg(reg_13, 'd13, "RW");
	 reg_map3.add_reg(reg_14, 'd14, "RW");
	 reg_map3.add_reg(reg_15, 'd15, "RW");		  
	 
	 set_hdl_path_root("top.d3");
     this.lock_model();
	 uvm_config_db#(uvm_reg_map)::set(null, "*", "reg_map0", reg_map0);
	 uvm_config_db#(uvm_reg_map)::set(null, "*", "reg_map1", reg_map1);
	 uvm_config_db#(uvm_reg_map)::set(null, "*", "reg_map2", reg_map2);
	 uvm_config_db#(uvm_reg_map)::set(null, "*", "reg_map3", reg_map3);
	  
   endfunction	: build

endclass : calc_reg_model