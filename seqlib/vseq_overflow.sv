class vseq_overflow extends vseq_base;
   
   calc_seq_overflow seq_overflow[4];
    
   `uvm_object_utils(vseq_overflow)
   
   function new(string name = "vseq_overflow");
      super.new(name);
   endfunction : new

   virtual task body();
      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
      
      apply_reset(3);  
      foreach (seq_overflow[j]) begin
         automatic int i = j;
         fork
         begin
            seq_overflow[i] = calc_seq_overflow::type_id::create($sformatf("seq_overflow%0d",i));
            seq_overflow[i].num_runs = 100;
            seq_overflow[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
      end  
	   wait fork;

   endtask : body
    
endclass : vseq_overflow