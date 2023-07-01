class calc_req_driver extends uvm_driver #(calc_req_trans);
   
   virtual Req_if req_if;
   virtual Reset_if rst_if;
   virtual Clock_if clk_if;
   
   bit [0:1] tag_queue[$] = {0,1,2,3};
   calc_req_trans fetch_queue[$];
   calc_out_trans output_collected;
   uvm_analysis_imp #(calc_out_trans, calc_req_driver) mon_drv_port_o;
   
   `uvm_component_utils(calc_req_driver)
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
      mon_drv_port_o = new("mon_drv_port_o", this);
   endfunction : new
   
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual protected task get_and_drive();
   extern virtual protected task handle_reset();
   extern virtual protected task run_checks();
   extern virtual function void write(calc_out_trans tr);
   
endclass : calc_req_driver

function void calc_req_driver::connect_phase(uvm_phase phase);

   super.connect_phase(phase);

   if(!uvm_config_db#(virtual Req_if)::get(this, get_full_name(), $sformatf("req_if.%0s", get_full_name), req_if))
      `uvm_error(this.get_type_name(), "req_if not found in config_db")
   if(!uvm_config_db#(virtual Reset_if)::get(this, get_full_name(), "rst_if", rst_if))
      `uvm_error(this.get_type_name(), "rst_if not found in config_db")
   if(!uvm_config_db#(virtual Clock_if)::get(this, get_full_name(), "clk_if", clk_if))
      `uvm_error(this.get_type_name(), "clk_if not found in config_db")
      
endfunction : connect_phase

task calc_req_driver::run_phase(uvm_phase phase);
   fork
      forever begin
         get_and_drive();
      end
      forever begin
         handle_reset();
      end
	  forever begin
         run_checks();
      end
   join
endtask : run_phase

task calc_req_driver::get_and_drive();

   bit [0:3] tmp_tag;

   `uvm_info(get_type_name(), "Driver waiting for seq", UVM_LOW)
   seq_item_port.get(req);

   wait(tag_queue.size() != 0);
   tmp_tag = tag_queue.pop_front();
   @(negedge clk_if.clk);
   req_if.req_cmd_in <=req.cmd_i; 
   req_if.req_data_in <= req.data_i;
   req_if.req_d1 <= req.d1_i;
   req_if.req_d2 <= req.d2_i;
   req_if.req_r1 <= req.r1_i;
   req_if.req_tag_in <= tmp_tag;
   req.tag_i <= tmp_tag;
   if(req.cmd_i == 10) begin
	   fetch_queue.push_back(req);	
   end else begin
      $cast(rsp, req.clone());
	   rsp.set_id_info(req);
      seq_item_port.put(rsp);
   end
   `uvm_info(get_full_name(), $sformatf("data = %0d, cmd = %0d, r1 = %0d, d1 = %0d, d2 = %0d, tag = %0d", req.data_i, req.cmd_i, req.r1_i, req.d1_i, req.d2_i, req_if.req_tag_in ), UVM_LOW)
   @(negedge clk_if.clk);
   req_if.req_cmd_in <= 0;
   req_if.req_data_in <= 0;
   req_if.req_d1 <= 0;
   req_if.req_d2 <= 0;
   req_if.req_r1 <= 0;   
   req_if.req_tag_in <= 0;

endtask : get_and_drive

task calc_req_driver::handle_reset();
   wait (rst_if.rst == 1);
   // reset input ports/signals
   req_if.req_cmd_in <= 0;
   req_if.req_data_in <= 0;
   req_if.req_d1 <= 0;
   req_if.req_d2 <= 0;
   req_if.req_r1 <= 0;   
   req_if.req_tag_in <= 0;
   // reset tag_queue
   tag_queue.delete();
   tag_queue = {0,1,2,3};
   //reset fetch_queue
   if (fetch_queue.size() != 0) begin
      foreach (fetch_queue[i]) begin
	      $cast(rsp, fetch_queue[i].clone());
		   rsp.set_id_info(fetch_queue[i]);
		   fetch_queue.delete(i);
		   seq_item_port.put(rsp);
	   end
   end
   @(negedge clk_if.clk);
   `uvm_info(get_full_name(), "handled reset", UVM_LOW)
endtask : handle_reset

task calc_req_driver::run_checks();
   // check that response is received within 100 clock cycles
	fork
	begin
	   wait(fetch_queue.size() != 0);
	   wait(fetch_queue.size() == 0);
	end
	begin
	   wait(fetch_queue.size() != 0);
	   repeat(100) @(negedge clk_if.clk);
	   `uvm_fatal(this.get_full_name(), "response not received after 100 clock cycles")
	end
	join_any
	disable fork;
endtask : run_checks

function void calc_req_driver::write(calc_out_trans tr);
   output_collected = tr;
   if (output_collected.resp_o != 0) begin
      tag_queue.push_back(output_collected.tag_o);
	   foreach(fetch_queue[i]) begin
	      if(fetch_queue[i].tag_i == output_collected.tag_o) begin
		      $cast(rsp, fetch_queue[i].clone());
			   rsp.set_id_info(fetch_queue[i]);
		      fetch_queue.delete(i);
		      rsp.data_i = output_collected.data_o;
		      seq_item_port.put(rsp);
	      end
	   end
   end
endfunction : write