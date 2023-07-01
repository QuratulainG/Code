class vseq_branch extends vseq_base;
   
   calc_seq_branch seq_branch[4];
    
   `uvm_object_utils(vseq_branch)
   
   function new(string name = "vseq_branch");
      super.new(name);
   endfunction : new

   virtual task body();

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
      
      apply_reset(3);  
      foreach (seq_branch[j]) begin
         automatic int i = j;
         fork
         begin
            seq_branch[i] = calc_seq_branch::type_id::create($sformatf("seq_branch%0d",i));
            seq_branch[i].num_runs = 100;
            seq_branch[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
      end  
	   wait fork;

    endtask : body
    
endclass : vseq_branch