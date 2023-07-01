class vseq_store_fetch extends vseq_base;
   
   `uvm_object_utils(vseq_store_fetch)
   
   function new(string name = "vseq_store_fetch");
      super.new(name);
    endfunction : new
  
   virtual task body();

      calc_seq_store_fetch seq_store_fetch[4];

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
        
      apply_reset(3);

      for (int i = 0; i < 4; i++)begin
         seq_store_fetch[i] = calc_seq_store_fetch::type_id::create($sformatf("seq_store_fetch%0d",i));
         seq_store_fetch[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]); // ch i
      end
      
   endtask : body
   
endclass : vseq_store_fetch