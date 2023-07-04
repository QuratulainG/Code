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
   
   covergroup req_cg;
      DATA1: coverpoint input_collected.data_i;
      D1: coverpoint input_collected.d1_i;
      D2: coverpoint input_collected.d2_i;
      R1: coverpoint input_collected.r1_i;
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
      
	   COV_ARITH_CMDs_X_REG: cross D1, D2, CMD {
                                               ignore_bins extra = binsof(CMD) intersect {9,10,12,13};
                                              }
									    
	   COV_STORE: cross CMD, R1, DATA1 {
                                       ignore_bins extra = !binsof (CMD.store);
                                      }
	   COV_FETCH: cross CMD, D1 {
                                ignore_bins extra = !binsof (CMD.fetch);
                               }
   endgroup
   
   covergroup out_cg;
      DATA0: coverpoint output_collected.data_o;
      RESP: coverpoint output_collected.resp_o {
                                                bins successful = {1};
                                                bins overflow = {2};
                                                bins branch = {3};
                                                bins invalid_resp = default;
                                               }
      DATA0_X_RESP: cross DATA0, RESP {
                                       ignore_bins extra = !binsof (RESP) intersect {1};
                                      }
   endgroup
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
      req_cg = new();
      out_cg = new();
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
             out_cg.sample();
         end
         item_collected_port_o.write(output_collected);
	  end

      if (input_collected.cmd_i != 0) begin
         if (coverage_enable) begin
            req_cg.sample();
         end
         item_collected_port_i.write(input_collected);
      end
   end

endtask : run_phase