class vseq_ral extends vseq_base;
   
   calc_seq_ral seq_ral[4];
   uvm_reg_map reg_map[4];
    
   `uvm_object_utils(vseq_ral)
   
   function new(string name = "vseq_ral");
      super.new(name);

      foreach(reg_map[i]) begin
         uvm_config_db#(uvm_reg_map)::get(get_sequencer(), "", $sformatf("reg_map%0d", i), reg_map[i]);
      end

   endfunction : new

   virtual task body();

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
	   
	   apply_reset(3);
	   foreach (seq_ral[j]) begin
         automatic int i = j;
         fork
         begin
            seq_ral[i] = calc_seq_ral::type_id::create($sformatf("seq_ral%0d",i));
            seq_ral[i].map = reg_map[i];
            seq_ral[i].num_runs = 100;
            seq_ral[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
	   end
      wait fork;
      
   endtask : body
    
endclass : vseq_ral