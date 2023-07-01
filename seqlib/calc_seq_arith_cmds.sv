class calc_seq_arith_cmds extends calc_seq_base();

   int num_runs = 1;

   `uvm_object_utils(calc_seq_arith_cmds)
   
   function new(string name = "calc_seq_arith_cmds");
      super.new(name);
   endfunction : new
   
   virtual task body();

      int op1_reg, op2_reg, out_reg;
      bit [0:31] op1, op2;
      bit [0:3] cmd, tmp_reg_q[$];
      bit [0:31] result, pred_result;

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)

      repeat(num_runs) begin

         // get available registers
         tmp_reg_q.delete();
         get_rand_reg(3, tmp_reg_q);
         op1_reg = tmp_reg_q[0];
         op2_reg = tmp_reg_q[1];
         out_reg = tmp_reg_q[2];

         // randomomize operands and cmd
         op1 = $urandom();
         op2 = $urandom();
         std::randomize (cmd) with {cmd inside {1,2,5,6};};

         // store value > do arith operation > fetch value
         do_store(op1_reg, op1);
		 wait_clk_cycles(4);
         do_store(op2_reg, op2);
         wait_clk_cycles(4);
         do_arith(op1_reg, op2_reg, out_reg, cmd);
         wait_clk_cycles(4);
         do_fetch(out_reg, result);

         // predict result
         case (cmd)
            1: pred_result = op1 + op2;
            2: pred_result = op1 - op2;
            5: pred_result = op1 << op2[27:31];
            6: pred_result = op1 >> op2[27:31];
         endcase

         // check result
         if (pred_result == result) begin
            `uvm_info(get_full_name(), $sformatf("Pass: result %0h pred_result %0h", result, pred_result), UVM_LOW)
         end else begin
            `uvm_error(get_full_name(), $sformatf("Fail: result %0h pred_result %0h", result, pred_result))
         end

         // put registers back in available reg queue
         reg_queue.push_back(op1_reg);
         reg_queue.push_back(op2_reg);
		   reg_queue.push_back(out_reg);
      end
      
   endtask : body
   
endclass : calc_seq_arith_cmds