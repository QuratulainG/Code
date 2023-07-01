class calc_seq_base extends uvm_sequence #(calc_req_trans);
   
   virtual Clock_if clk_if;
   bit [0:3] reg_op1, reg_op2, reg_out;

   static semaphore key;
   
   //static bit [0:3] reg_queue[$] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}; // FIXME: reg 13 has bug
   static bit [0:3] reg_queue[$] = {0,1,2,3,4,5,6,7,8,9,10,11,12,14,15};
   
   `uvm_object_utils(calc_seq_base)
      
   function new(string name = "calc_seq_base");
      super.new(name);

      if(!uvm_config_db#(virtual Clock_if)::get(null, get_full_name(), "clk_if", clk_if))
          `uvm_error(this.get_type_name(), {"clk_if not found in config_db"})

      if (key == null) key = new(1);

   endfunction : new

   virtual task get_rand_reg(int num = 1, output bit [0:3] m_reg_q[$]);
      key.get(1);
      wait(reg_queue.size() > num);
      reg_queue.shuffle();
      repeat (num) begin
         m_reg_q.push_back(reg_queue.pop_front());
      end
      key.put(1);
   endtask : get_rand_reg

   virtual task do_store(int reg_num, int data);
      calc_req_trans req = calc_req_trans::type_id::create("req");
      req.cmd_i = 9;
      req.data_i = data;
      req.r1_i = reg_num;
      start_item(req);
		`uvm_info(get_full_name(), $sformatf("do_store value = %0d to reg = %0d", req.data_i, req.r1_i), UVM_LOW)
		finish_item(req);
      get_response(rsp, req.get_transaction_id()); 
   endtask : do_store

   virtual task do_fetch(int reg_num, output int data);
      calc_req_trans req = calc_req_trans::type_id::create("req");
      req.cmd_i = 10;
      req.d1_i = reg_num;
      start_item(req);
		`uvm_info(get_full_name(), $sformatf("do_fetch from reg = %0d", req.d1_i), UVM_LOW)
		finish_item(req);
      get_response(rsp, req.get_transaction_id());
      data = rsp.data_i;
   endtask : do_fetch

   virtual task do_arith(int op1_reg, op2_reg, out_reg, cmd);
      calc_req_trans req = calc_req_trans::type_id::create("req");
      if (!(cmd inside {1,2,5,6})) begin
        `uvm_fatal(get_full_name(), "invalid arith cmd provided")
      end
      req.d1_i = op1_reg;
      req.d2_i = op2_reg;
      req.r1_i = out_reg;
      req.cmd_i = cmd;
      start_item(req);
		`uvm_info(get_full_name(), $sformatf("do_arith op1_reg %0d op2_reg %0d out_reg %0d cmd %0d", op1_reg, op2_reg, out_reg, cmd), UVM_LOW)
		finish_item(req);
      get_response(rsp, req.get_transaction_id());
   endtask : do_arith

   virtual task do_branch(int op1_reg, op2_reg, cmd);
      calc_req_trans req = calc_req_trans::type_id::create("req");
      if (!(cmd inside {12,13})) begin
        `uvm_fatal(get_full_name(), "invalid branch cmd provided")
      end
      req.d1_i = op1_reg;
      req.d2_i = op2_reg;
      req.cmd_i = cmd;
      start_item(req);
		`uvm_info(get_full_name(), $sformatf("do_arith op1_reg %0d op2_reg %0d cmd %0d", op1_reg, op2_reg, cmd), UVM_LOW)
		finish_item(req);
      get_response(rsp, req.get_transaction_id());
   endtask : do_branch

   virtual task wait_clk_cycles(int cycles);
      repeat(cycles) begin
         @(negedge clk_if.clk);
      end
   endtask : wait_clk_cycles

endclass : calc_seq_base
