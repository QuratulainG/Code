class calc_seq_ral extends calc_seq_ral_base();

   int num_runs = 1;
   uvm_reg_map map;

   `uvm_object_utils(calc_seq_ral)
   
   function new(string name = "calc_seq_ral");
      super.new(name);
   endfunction : new
   
   virtual task body();

      int op1_reg;
      bit [0:31] op1;
      bit [0:3]  tmp_reg_q[$];
      bit [0:31] result, pred_result;

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)

      repeat(num_runs) begin

         // get available register
         tmp_reg_q.delete();
         get_rand_reg(1, tmp_reg_q);
         op1_reg = tmp_reg_q[0];
         
         // randomomize operand
         op1 = $urandom();
         
         // store value > fetch value
		   write_reg(op1_reg, op1, map);
		   wait_clk_cycles(3);
		   read_reg(op1_reg, result, map);

         // predict result        
         pred_result = op1 ;            

         // check result
         if (pred_result == result) begin
            `uvm_info(get_full_name(), $sformatf("Pass: result %0h pred_result %0h", result, pred_result), UVM_LOW)
         end else begin
            `uvm_error(get_full_name(), $sformatf("Fail: result %0h pred_result %0h", result, pred_result))
         end
		 
         // put registers back in available reg queue
         reg_queue.push_back(op1_reg);
         
      end
      
   endtask : body
   
endclass : calc_seq_ral