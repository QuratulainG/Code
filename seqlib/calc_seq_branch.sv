class calc_seq_branch extends calc_seq_base();

   int num_runs = 1;
	
   `uvm_object_utils(calc_seq_branch)
   
   function new(string name = "calc_seq_branch");
      super.new(name);
   endfunction : new
   
   virtual task body();

      int op1_reg, op2_reg, test_reg;
      bit [0:31] op1, op2;
      bit [0:3] cmd, tmp_reg_q[$];
      bit [0:31] test_value, result, pred_result;

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)

	  repeat (num_runs) begin

	     // get available registers
         tmp_reg_q.delete();
         get_rand_reg(3, tmp_reg_q);
         op1_reg  = tmp_reg_q[0];
	     op2_reg  = tmp_reg_q[1];
	     test_reg = tmp_reg_q[2];

	     // read value in test_reg
         do_fetch(test_reg, test_value);

         // store random value to op1_reg
	     // 50% chance for value to be zero
		 // 50% change to have values from 'h0 to 'hFFFFFFFF
         std::randomize (op1) with {op1 dist {0 := 50, [32'h1:32'hFFFFFFFF] :/ 50};};
	     do_store(op1_reg, op1);

         // store random value to op2_reg
	     // 50% chance for value to be equal to op1
		 // 50% change to have values from 'h0 to 'hFFFFFFFF
	     std::randomize (op2) with {op2 dist {op1 := 50, [32'h0:32'hFFFFFFFF] :/ 50};};
	     do_store(op2_reg, op2);

	     wait_clk_cycles(4);
			
	     // send branch cmd
	     std::randomize (cmd) with {cmd inside {12,13};};
	     do_branch(op1_reg, op2_reg, cmd);

         wait_clk_cycles(4);

	     // do next cmd that might be be skipped
	     do_store(test_reg, test_value+1);

	     // predict result
	     if ((cmd == 12) && (op1 == 0)) begin // branch if zero
	        pred_result = test_value;
	     end else if ((cmd == 13) && (op1 == op2)) begin // branch if equal
		    pred_result = test_value;
	     end else begin
		    pred_result = test_value+1;
	     end

         // check result
		 wait_clk_cycles(3);
		 do_fetch(test_reg, result);
	     if (pred_result == result) begin
		    `uvm_info(get_full_name(), $sformatf("Pass: cmd %0d op1 %0d op2 %0d result %0h pred_result %0h test_value %0h", cmd, op1, op2, result, pred_result, test_value), UVM_LOW)
	     end else begin
		    `uvm_error(get_full_name(), $sformatf("Fail: cmd %0d op1 %0d op2 %0d result %0h pred_result %0h test_value %0h", cmd, op1, op2, result, pred_result, test_value))
	     end

	     // put registers back in available reg queue
         reg_queue.push_back(op1_reg);
         reg_queue.push_back(op2_reg);
	     reg_queue.push_back(test_reg);

	  end
	  
   endtask : body
   
endclass : calc_seq_branch