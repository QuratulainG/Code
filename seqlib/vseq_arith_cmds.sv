class vseq_arith_cmds extends vseq_base;
   
	calc_seq_arith_cmds seq_arith_cmds[4];
   
   `uvm_object_utils(vseq_arith_cmds)
   
   function new(string name = "vseq_arith_cmds");
      super.new(name);
   endfunction : new

   virtual task body();
      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
      
      apply_reset(3);

	   foreach (seq_arith_cmds[j]) begin
         automatic int i = j;
         fork
         begin
            seq_arith_cmds[i] = calc_seq_arith_cmds::type_id::create($sformatf("seq_arith_cmds%0d",i));
            seq_arith_cmds[i].num_runs = 100;
            seq_arith_cmds[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
      end
      wait fork;
	  
    endtask : body
    
endclass : vseq_arith_cmds
