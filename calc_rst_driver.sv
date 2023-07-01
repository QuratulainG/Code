class calc_rst_driver extends uvm_driver #(calc_rst_trans);
   
   virtual Reset_if rst_if;
   virtual Clock_if clk_if;
   
   `uvm_component_utils(calc_rst_driver)
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   
endclass : calc_rst_driver

function void calc_rst_driver::connect_phase(uvm_phase phase);

   super.connect_phase(phase);

   if(!uvm_config_db#(virtual Reset_if)::get(this, get_full_name(), "rst_if", rst_if))
      `uvm_error(this.get_type_name(), "rst_if not found in config_db")
   if(!uvm_config_db#(virtual Clock_if)::get(this, get_full_name(), "clk_if", clk_if))
      `uvm_error(this.get_type_name(), "clk_if not found in config_db")
      
endfunction : connect_phase

task calc_rst_driver::run_phase(uvm_phase phase);
   forever begin
      seq_item_port.get_next_item(req);

      rst_if.rst <= req.rst;
      repeat (req.clk_cycles) begin
         @(negedge clk_if.clk);
      end 
      rst_if.rst <= 0;

      seq_item_port.item_done(req);
   end
endtask : run_phase