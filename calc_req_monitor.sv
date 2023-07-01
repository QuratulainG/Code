class calc_req_monitor extends uvm_monitor;
   
   bit coverage_enable = 1;
   virtual Out_if out_if;
   virtual Req_if req_if;
   virtual Clock_if clk_if;
   
   uvm_analysis_port #(calc_out_trans) item_collected_port_o;
   uvm_analysis_port #(calc_req_trans) item_collected_port_i;
   
   calc_out_trans output_collected;
   calc_req_trans input_collected;
 
   `uvm_component_utils(calc_req_monitor)
   
   covergroup transaction_cg;
      DATA_IN: coverpoint input_collected.data_i;
      D1: coverpoint input_collected.d1_i;
      D2: coverpoint input_collected.d2_i;
      REG_IN: coverpoint input_collected.r1_i;
      CMD: coverpoint input_collected.cmd_i {
                                             bins add = {1};
                                             bins sub = {2};
                                             bins shift_left = {5};
                                             bins shift_right = {6};
                                             bins store = {9};
                                             bins fetch = {10};
                                             bins branch_if_zero = {12};
                                             bins branch_if_equal = {13};
                                             bins invalid_cmd = default;
                                            }
      
      DATA_IN_X_CMD: cross DATA_IN, CMD { 
										ignore_bins invalid_fetch = binsof (DATA_IN) intersect {[67108864:$]}	&& binsof (CMD) intersect {10} ;
                                        }
	   D1_X_D2_X_CMD: cross D1, D2, CMD {
										ignore_bins extra = binsof(CMD) intersect {[9:10]};
								        ignore_bins invalid_cmd = D1_X_D2_X_CMD with ((CMD == 1 || CMD == 2 || CMD == 5 || CMD == 6) && D1 == D2);
                                        }
									    
	  REG_IN_X_CMD: cross REG_IN, CMD {
				  					  ignore_bins extra = REG_IN_X_CMD with (CMD != 9);
                                      }
	  D1_X_CMD: cross D1, CMD {
							  ignore_bins extra = D1_X_CMD with (CMD != 10);
                              }
   endgroup
   
   covergroup result_cg;
      DATA_OUT: coverpoint output_collected.data_o;
      RESP: coverpoint output_collected.resp_o {
                                                bins successful = {1};
                                                bins overflow = {2};
                                                bins branch = {3};
                                                bins invalid_resp = default;
                                               }
      DATA_OUT_X_RESP: cross DATA_OUT, RESP {
	                                       	ignore_bins invalid_branch = binsof (DATA_OUT) intersect {[67108864:$]}	&& binsof (RESP) intersect {2};				
											ignore_bins invalid_overflow = binsof (DATA_OUT) intersect {[67108864:$]}	&& binsof (RESP) intersect {3};
                                            }
   endgroup
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
      transaction_cg = new();
      result_cg = new();
      item_collected_port_o = new("item_collected_port_o", this);
      item_collected_port_i = new("item_collected_port_i", this);
   endfunction : new

   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
  
endclass : calc_req_monitor

function void calc_req_monitor::connect_phase(uvm_phase phase);

   super.connect_phase(phase);

   if(!uvm_config_db#(virtual Out_if)::get(this, get_full_name(), $sformatf("out_if.%0s", get_full_name), out_if))
      `uvm_error(this.get_type_name(), "out_if not found in config_db")
   if(!uvm_config_db#(virtual Req_if)::get(this, get_full_name(), $sformatf("req_if.%0s", get_full_name), req_if))
      `uvm_error(this.get_type_name(), "req_if not found in config_db")
   if(!uvm_config_db#(virtual Clock_if)::get(this, get_full_name(), "clk_if", clk_if))
      `uvm_error(this.get_type_name(), "clk_if not found in config_db")

endfunction : connect_phase

task calc_req_monitor::run_phase(uvm_phase phase);

   forever begin  
      input_collected = calc_req_trans::type_id::create("input_collected");
      output_collected = calc_out_trans::type_id::create("output_collected");
      @(negedge clk_if.clk);
   
      output_collected.data_o = out_if.out_data;
      output_collected.resp_o = out_if.out_resp;
      output_collected.tag_o = out_if.out_tag;
      input_collected.cmd_i = req_if.req_cmd_in;
      input_collected.data_i = req_if.req_data_in;
      input_collected.d1_i = req_if.req_d1;
      input_collected.d2_i = req_if.req_d2;
      input_collected.tag_i = req_if.req_tag_in;
      input_collected.r1_i = req_if.req_r1;

      if (output_collected.resp_o != 0) begin 
         if (coverage_enable) begin
            result_cg.sample();
         end
         item_collected_port_o.write(output_collected);
	  end

      if (input_collected.cmd_i != 0) begin
         if (coverage_enable) begin
            transaction_cg.sample();
         end
         item_collected_port_i.write(input_collected);
      end
   end

endtask : run_phase