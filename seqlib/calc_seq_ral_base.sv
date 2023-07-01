class calc_seq_ral_base extends uvm_sequence #(calc_req_trans);
   
   virtual Clock_if clk_if;
   calc_reg_model m_reg_model;
   uvm_reg_map map;
   
   static bit [0:3] reg_queue[$] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
   static semaphore key;
   
   `uvm_object_utils(calc_seq_ral_base)
      
   function new(string name = "calc_seq_ral_base");
      super.new(name); 
	  
	  if(!uvm_config_db#(virtual Clock_if)::get(null, get_full_name(), "clk_if", clk_if))
         `uvm_error(this.get_type_name(), "clk_if not found in config_db")
	  
	  if(!uvm_config_db#(calc_reg_model)::get(get_sequencer(), "", "m_reg_model", m_reg_model))
	     `uvm_error(this.get_type_name(), "m_reg_model not found in config_db")

	  if (key == null) key = new(1);
	  
   endfunction : new
  
   virtual task write_reg(input int reg_num, input bit[0:31] data, input uvm_reg_map map);
   	  uvm_status_e status;
	  case(reg_num) 
	      0 : m_reg_model.reg_0.write(status, data, UVM_FRONTDOOR, .map(map));
		  1 : m_reg_model.reg_1.write(status, data, UVM_FRONTDOOR, .map(map));
		  2 : m_reg_model.reg_2.write(status, data, UVM_FRONTDOOR, .map(map));
		  3 : m_reg_model.reg_3.write(status, data, UVM_FRONTDOOR, .map(map));
		  4 : m_reg_model.reg_4.write(status, data, UVM_FRONTDOOR, .map(map));
		  5 : m_reg_model.reg_5.write(status, data, UVM_FRONTDOOR, .map(map));
		  6 : m_reg_model.reg_6.write(status, data, UVM_FRONTDOOR, .map(map));
		  7 : m_reg_model.reg_7.write(status, data, UVM_FRONTDOOR, .map(map));
		  8 : m_reg_model.reg_8.write(status, data, UVM_FRONTDOOR, .map(map));
		  9 : m_reg_model.reg_9.write(status, data, UVM_FRONTDOOR, .map(map));
		 10 : m_reg_model.reg_10.write(status, data, UVM_FRONTDOOR, .map(map));
		 11 : m_reg_model.reg_11.write(status, data, UVM_FRONTDOOR, .map(map));
		 12 : m_reg_model.reg_12.write(status, data, UVM_FRONTDOOR, .map(map));
		 13 : m_reg_model.reg_13.write(status, data, UVM_FRONTDOOR, .map(map));
		 14 : m_reg_model.reg_14.write(status, data, UVM_FRONTDOOR, .map(map));
		 15 : m_reg_model.reg_15.write(status, data, UVM_FRONTDOOR, .map(map));
		 default : `uvm_fatal ("INVALID_REG", "Invalid reg_num provided.")
	  endcase
   endtask : write_reg
   
   virtual task read_reg(input int reg_num, output bit[0:31] data, input uvm_reg_map map);
      uvm_status_e status;	  
	  case(reg_num) 
	      0 : m_reg_model.reg_0.read(status, data, UVM_FRONTDOOR, .map(map));
		  1 : m_reg_model.reg_1.read(status, data, UVM_FRONTDOOR, .map(map));
		  2 : m_reg_model.reg_2.read(status, data, UVM_FRONTDOOR, .map(map));
		  3 : m_reg_model.reg_3.read(status, data, UVM_FRONTDOOR, .map(map));
		  4 : m_reg_model.reg_4.read(status, data, UVM_FRONTDOOR, .map(map));
		  5 : m_reg_model.reg_5.read(status, data, UVM_FRONTDOOR, .map(map));
		  6 : m_reg_model.reg_6.read(status, data, UVM_FRONTDOOR, .map(map));
		  7 : m_reg_model.reg_7.read(status, data, UVM_FRONTDOOR, .map(map));
		  8 : m_reg_model.reg_8.read(status, data, UVM_FRONTDOOR, .map(map));
		  9 : m_reg_model.reg_9.read(status, data, UVM_FRONTDOOR, .map(map));
		 10 : m_reg_model.reg_10.read(status, data, UVM_FRONTDOOR, .map(map));
		 11 : m_reg_model.reg_11.read(status, data, UVM_FRONTDOOR, .map(map));
		 12 : m_reg_model.reg_12.read(status, data, UVM_FRONTDOOR, .map(map));
		 13 : m_reg_model.reg_13.read(status, data, UVM_FRONTDOOR, .map(map));
		 14 : m_reg_model.reg_14.read(status, data, UVM_FRONTDOOR, .map(map));
		 15 : m_reg_model.reg_15.read(status, data, UVM_FRONTDOOR, .map(map));
		 default : `uvm_fatal ("INVALID_REG", "Invalid reg_num provided.")
	  endcase
   endtask : read_reg 
   
   virtual task wait_clk_cycles(int cycles);
      repeat(cycles) begin
         @(negedge clk_if.clk);
      end
   endtask : wait_clk_cycles
   
   virtual task get_rand_reg(int num = 1, output bit [0:3] m_reg_q[$]);
      key.get(1);
      wait(reg_queue.size() > num);
      reg_queue.shuffle();
      repeat (num) begin
         m_reg_q.push_back(reg_queue.pop_front());
      end
      key.put(1);
   endtask : get_rand_reg

endclass : calc_seq_ral_base
