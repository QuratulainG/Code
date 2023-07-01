class vseq_walking_1s_0s extends vseq_base;
   
   calc_seq_walking_1s_0s seq_walking_1s_0s[4];
    
   `uvm_object_utils(vseq_walking_1s_0s)
   
   function new(string name = "vseq_walking_1s_0s");
      super.new(name);
    endfunction : new
   
   virtual task body();

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
      
	   apply_reset(3);
      foreach(seq_walking_1s_0s[i]) begin
         seq_walking_1s_0s[i] = calc_seq_walking_1s_0s::type_id::create($sformatf("seq_walking_1s_0s%0d",i));
         seq_walking_1s_0s[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]); 
      end  
   endtask : body    
   
endclass : vseq_walking_1s_0s