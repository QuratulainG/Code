class calc_seq_store_fetch extends calc_seq_base();

   static int store_data[16];
   
   `uvm_object_utils(calc_seq_store_fetch)
   
   function new(string name = "calc_seq_store_fetch");
      super.new(name);
   endfunction : new
   
   virtual task body();

      int fetch_data;

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)

      for (int i = 0; i < 16; i++) begin // store to all 16 registers
         store_data[i] = $urandom();
         do_store (i, store_data[i]);

         for (int j = 0; j < 16; j++) begin // fetch from all 16 registers
            do_fetch(j, fetch_data);
            if (store_data[j] == fetch_data) begin
               `uvm_info(get_full_name(), $sformatf("Pass: reg %0d, fetched_data %0h expected_data %0h", j, fetch_data, store_data[j]), UVM_LOW)
            end else begin
               `uvm_error(get_full_name(), $sformatf("Fail: reg %0d, fetched_data %0h expected_data %0h", j, fetch_data, store_data[j]))
            end
         end
      end
      
   endtask : body
   
endclass : calc_seq_store_fetch