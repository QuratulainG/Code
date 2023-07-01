`uvm_analysis_imp_decl(_port_i_0)
`uvm_analysis_imp_decl(_port_i_1)
`uvm_analysis_imp_decl(_port_i_2)
`uvm_analysis_imp_decl(_port_i_3)
`uvm_analysis_imp_decl(_port_o_0)
`uvm_analysis_imp_decl(_port_o_1)
`uvm_analysis_imp_decl(_port_o_2)
`uvm_analysis_imp_decl(_port_o_3)

class calc_req_scbd extends uvm_scoreboard;

   uvm_analysis_imp_port_i_0 #(calc_req_trans, calc_req_scbd) scbd_port_i_0;
   uvm_analysis_imp_port_i_1 #(calc_req_trans, calc_req_scbd) scbd_port_i_1;
   uvm_analysis_imp_port_i_2 #(calc_req_trans, calc_req_scbd) scbd_port_i_2;
   uvm_analysis_imp_port_i_3 #(calc_req_trans, calc_req_scbd) scbd_port_i_3;   
   uvm_analysis_imp_port_o_0 #(calc_out_trans, calc_req_scbd) scbd_port_o_0;
   uvm_analysis_imp_port_o_1 #(calc_out_trans, calc_req_scbd) scbd_port_o_1;
   uvm_analysis_imp_port_o_2 #(calc_out_trans, calc_req_scbd) scbd_port_o_2;
   uvm_analysis_imp_port_o_3 #(calc_out_trans, calc_req_scbd) scbd_port_o_3;
  
   calc_out_trans predicted_q0[$], predicted_q1[$], predicted_q2[$], predicted_q3[$];
   calc_out_trans monitored_q0[$], monitored_q1[$], monitored_q2[$], monitored_q3[$];
   
   virtual Clock_if clk_if;
   virtual Reset_if rst_if;
   
   bit [0:31] register_model[16];
   bit [0:31] op1, op2, out;
   bit [0:3] cmd;
   bit branch[int];
   int count_pass, count_fail, count_skip;
   bit coverage_enable = 1;
   
   covergroup command_cg;
	   OP1 : coverpoint op1;
	   OP2 : coverpoint op2;
	   CMD: coverpoint cmd {
		   				      bins add = {1};
						         bins sub = {2};
						         bins shift_left = {5};
						         bins shift_right = {6};
						         bins branch_if_zero = {12};
						         bins branch_if_equal = {13};
						         bins invalid_cmd = default;
                          } 
	   OP1_X_OP2_X_CMD: cross OP1, OP2, CMD {ignore_bins extra = binsof(CMD.branch_if_zero);}
	   OP1_X_BR_IF_ZERO: cross OP1, CMD {ignore_bins extra = OP1_X_BR_IF_ZERO with (CMD != 12);}
   endgroup 
   
   `uvm_component_utils(calc_req_scbd)
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
      command_cg = new();
      branch[0] = 0;
      branch[1] = 0;
      branch[2] = 0;
      branch[3] = 0;
      scbd_port_i_0 = new ("scbd_port_i_0", this);
      scbd_port_i_1 = new ("scbd_port_i_1", this);
      scbd_port_i_2 = new ("scbd_port_i_2", this);
      scbd_port_i_3 = new ("scbd_port_i_3", this);
      scbd_port_o_0 = new ("scbd_port_o_0", this);
      scbd_port_o_1 = new ("scbd_port_o_1", this);
      scbd_port_o_2 = new ("scbd_port_o_2", this);
      scbd_port_o_3 = new ("scbd_port_o_3", this); 
    endfunction : new
    
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      if(!uvm_config_db#(virtual Clock_if)::get(this, get_full_name(), "clk_if", clk_if))
      `uvm_error(this.get_type_name(), "clk_if not found in config_db")
      if(!uvm_config_db#(virtual Reset_if)::get(this, get_full_name(), "rst_if", rst_if))
      `uvm_error(this.get_type_name(), "rst_if not found in config_db")

   endfunction : connect_phase
   
   virtual function void write_port_i_0(calc_req_trans req);
      cmd = req.cmd_i;
      predicted_q0.push_back(predict_out(req, 0));
   endfunction : write_port_i_0
   
   virtual function void write_port_i_1(calc_req_trans req);
      cmd = req.cmd_i;
      predicted_q1.push_back(predict_out(req, 1)); 
   endfunction : write_port_i_1
   
   virtual function void write_port_i_2(calc_req_trans req);
      cmd = req.cmd_i;
 	   predicted_q2.push_back(predict_out(req, 2)); 
   endfunction : write_port_i_2
   
   virtual function void write_port_i_3(calc_req_trans req);
      cmd = req.cmd_i;
	   predicted_q3.push_back(predict_out(req, 3));    
   endfunction : write_port_i_3
   
   virtual function void write_port_o_0(calc_out_trans out);
      monitored_q0.push_back(out);
   endfunction : write_port_o_0
   
   virtual function void write_port_o_1(calc_out_trans out);
      monitored_q1.push_back(out);
   endfunction : write_port_o_1
   
   virtual function void write_port_o_2(calc_out_trans out);
      monitored_q2.push_back(out);
   endfunction : write_port_o_2
   
   virtual function void write_port_o_3(calc_out_trans out);
      monitored_q3.push_back(out);
   endfunction : write_port_o_3
   
   virtual function calc_out_trans predict_out(input calc_req_trans input_tr, int channel);

      calc_out_trans pred_out = calc_out_trans::type_id::create("pred_out");
      
      pred_out.tag_o  = input_tr.tag_i;
      pred_out.data_o = 0;
      pred_out.resp_o = 1;

      if (branch[channel] == 1) begin
         pred_out.resp_o = 3;
         branch[channel] = 0;
         count_skip++;
         `uvm_info(get_full_name(), $sformatf("ch%0d: command %0d skipped due to branch.", channel, input_tr.cmd_i), UVM_LOW)
         return pred_out;
      end

      case(input_tr.cmd_i)
        09: begin // store
               register_model[input_tr.r1_i] = input_tr.data_i;
            end            
        10: begin // fetch
               out = register_model[input_tr.d1_i];
               pred_out.data_o = register_model[input_tr.d1_i];
            end
        01: begin // add
               bit [0:31] tmp;
               op1 = register_model[input_tr.d1_i];
               op2 = register_model[input_tr.d2_i];
               out = op1 + op2;
               register_model[input_tr.r1_i] = out;  
               tmp = 32'hFFFFFFFF - op1;
               if (op2 > tmp) pred_out.resp_o = 2;
            end
        02: begin // sub
               op1 = register_model[input_tr.d1_i];
               op2 = register_model[input_tr.d2_i];
               out = op1 - op2;
               register_model[input_tr.r1_i] = out;
               if (op2 > op1) pred_out.resp_o = 2;
            end 
        05: begin // shift left
               op1 = register_model[input_tr.d1_i];
               op2 = register_model[input_tr.d2_i];
               out = op1 << op2[27:31];
               register_model[input_tr.r1_i] = out;
            end
        06: begin // shift right
               op1 = register_model[input_tr.d1_i];
               op2 = register_model[input_tr.d2_i];
               out = op1 >> op2[27:31];
               register_model[input_tr.r1_i] = out;
            end 
        12: begin // branch if zero   
               op1 = register_model[input_tr.d1_i];
               if (op1 == 0) begin
                  branch[channel] = 1;
                  pred_out.data_o = 1;
               end
            end
        13: begin // branch if equal
               op1 = register_model[input_tr.d1_i];
               op2 = register_model[input_tr.d2_i];
               if (op1 == op2) begin
                  branch[channel] = 1;
                  pred_out.data_o = 1;
               end
            end
      endcase
      `uvm_info(get_full_name(), $sformatf("ch%0d: command %0d given, data_i = %0h, data_o = %0h, resp_o = %0d", channel, input_tr.cmd_i, input_tr.data_i, pred_out.data_o, pred_out.resp_o), UVM_LOW) 
      if (coverage_enable) command_cg.sample();
      return pred_out;
   endfunction : predict_out
       
   virtual task compare_result(bit [0:1] channel, ref calc_out_trans predicted_q[$], monitored_q[$]);  
      forever begin	
         calc_out_trans temp_mon, temp_pred;
         wait (monitored_q.size() != 0);		 
         temp_mon = monitored_q.pop_front();

         // find pred_trans
		   foreach (predicted_q[i]) begin
		      if (predicted_q[i].tag_o == temp_mon.tag_o) begin
			      temp_pred = predicted_q[i];
				   predicted_q.delete(i);
			      break;
		      end
		   end
		   if (temp_pred == null && rst_if.rst == 0) begin
            `uvm_error(get_full_name(), $sformatf("ERROR: predicted trans not found for %p", temp_mon))			
         end

         // compared mon and pred trans
         if (rst_if.rst == 1) begin
			   `uvm_info(get_full_name(), "Reset: Queue emptied due to reset", UVM_LOW)
		   end else if ((temp_mon.data_o == temp_pred.data_o) && (temp_mon.resp_o == temp_pred.resp_o)) begin
            count_pass++;
            `uvm_info(get_full_name(), $sformatf("Pass: predicted result same as actual. Tag = %0d. Count =%0d, Count_skip = %0d. Channel%0d", temp_pred.tag_o, count_pass, count_skip, channel), UVM_HIGH)
		   end else begin
            count_fail++;
            `uvm_error(get_full_name(), $sformatf("Fail: predicted result different from actual. Tag_pred = %0d, Tag_mon = %0d, Data_pred = %0d, Data_mon = %0d, Resp_pred = %0d, Resp_mon = %0d, Count =%0d, Count_skip = %0d. Channel%0d", temp_pred.tag_o, temp_mon.tag_o, temp_pred.data_o, temp_mon.data_o, temp_pred.resp_o, temp_mon.resp_o, count_fail, count_skip, channel))	
		   end
      end
   endtask : compare_result
   
   virtual task handle_reset();
      forever begin
	      wait(rst_if.rst == 1);
		   `uvm_info(get_full_name(), "handling reset", UVM_LOW)
		   predicted_q0.delete();
		   predicted_q1.delete();
		   predicted_q2.delete();
		   predicted_q3.delete();
		   monitored_q0.delete();
		   monitored_q1.delete();
		   monitored_q2.delete();
		   monitored_q3.delete();
		   foreach(register_model[i]) begin
			   register_model[i] = 0;
         end
		   @(negedge clk_if.clk);		
	   end
   endtask : handle_reset
   
   virtual task run_phase (uvm_phase phase);
      wait(rst_if.rst == 1);
      wait(rst_if.rst == 0);
      fork  
		   handle_reset();
         compare_result(0, predicted_q0, monitored_q0);
         compare_result(1, predicted_q1, monitored_q1);
         compare_result(2, predicted_q2, monitored_q2);
         compare_result(3, predicted_q3, monitored_q3);     
      join
   endtask : run_phase

endclass : calc_req_scbd