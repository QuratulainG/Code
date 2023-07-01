class calc_reg_adapter extends uvm_reg_adapter;
	`uvm_object_utils(calc_reg_adapter)
	
	function new(string name = "calc_reg_adapter");
		super.new(name);
		provides_responses = 1;
	endfunction : new
	
	virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		calc_req_trans transfer;
		transfer = calc_req_trans::type_id::create("transfer");
		if (rw.kind == UVM_READ) begin
		   transfer.cmd_i = 'd10;
		   transfer.d1_i = rw.addr;
		   transfer.data_i = rw.data;
		   `uvm_info(get_full_name(), $sformatf("REG2BUS: read addr = %0d, data = %0d", rw.addr, rw.data), UVM_LOW)
		end
		else if(rw.kind == UVM_WRITE) begin
		   transfer.cmd_i = 'd9;
		   transfer.r1_i = rw.addr;
		   transfer.data_i = rw.data;
		   `uvm_info(get_full_name(), $sformatf("REG2BUS: write addr = %0d, data = %0d", rw.addr, rw.data), UVM_LOW)
		end
		return(transfer);	
	endfunction : reg2bus
	
	virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		calc_req_trans transfer;
		if(!$cast(transfer, bus_item)) begin
	       `uvm_fatal(get_full_name(), "Incorrect bus item. Expecting calc_req_trans")
		   return;
		end
		if(transfer.cmd_i == 'd10) begin
		   rw.kind = UVM_READ;
		   rw.addr = transfer.d1_i;
		   rw.data = transfer.data_i;
		   rw.status = UVM_IS_OK;
		   `uvm_info(get_full_name(), $sformatf("BUS2REG: read addr = %0d, data = %0d", rw.addr, rw.data), UVM_LOW)
		end
		else if(transfer.cmd_i == 'd9) begin
		   rw.kind = UVM_WRITE;
		   rw.addr = transfer.r1_i;
		   rw.data = transfer.data_i;
		   rw.status = UVM_IS_OK;
		   `uvm_info(get_full_name(), $sformatf("BUS2REG: write addr = %0d, data = %0d", rw.addr, rw.data), UVM_LOW)
		end
		
	endfunction : bus2reg

endclass : calc_reg_adapter