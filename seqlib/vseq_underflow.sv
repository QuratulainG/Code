class vseq_underflow extends vseq_base;
   
   calc_seq_underflow seq_underflow[4];
    
   `uvm_object_utils(vseq_underflow)
   
   function new(string name = "vseq_underflow");
      super.new(name);
   endfunction : new

   virtual task body();
      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
      
      apply_reset(3);  
      foreach (seq_underflow[j]) begin
         automatic int i = j;
         fork
         begin
            seq_underflow[i] = calc_seq_underflow::type_id::create($sformatf("seq_underflow%0d",i));
            seq_underflow[i].num_runs = 100;
            seq_underflow[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
      end  
	   wait fork;

   endtask : body
    
endclass : vseq_underflow