class vseq_reset extends vseq_base;
       
   `uvm_object_utils(vseq_reset)
   
   function new(string name = "vseq_reset");
      super.new(name);
   endfunction : new

   // sequence steps:
   // 01. run arith_cmds seq
   // 02. apply reset
   // 03. run arith_cmds seq
   // 04. apply reset
   // 05. run branch seq
   // 06. apply reset
   // 07. run branch seq
   virtual task body();

      calc_seq_arith_cmds seq_arith_cmds[4];
      calc_seq_branch seq_branch[4];

      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
	  
      apply_reset(3);

      foreach (seq_arith_cmds[j]) begin
         automatic int i = j;
         fork
         begin
            seq_arith_cmds[i] = calc_seq_arith_cmds::type_id::create($sformatf("seq_arith_cmds%0d",i));
            seq_arith_cmds[i].num_runs = 10;
			`uvm_info(get_full_name, $sformatf("ar1 start seq %0d", i), UVM_LOW)
            seq_arith_cmds[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
      end
      wait fork;
    
      apply_reset(3);

      foreach (seq_arith_cmds[j]) begin
         automatic int i = j; 
         fork
         begin
            seq_arith_cmds[i] = calc_seq_arith_cmds::type_id::create($sformatf("seq_arith_cmds%0d",i));
            seq_arith_cmds[i].num_runs = 10;
			`uvm_info(get_full_name, $sformatf("ar2 start seq %0d", i), UVM_LOW)		
            seq_arith_cmds[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
      end
      wait fork;

      apply_reset(3);

      foreach (seq_branch[j]) begin
         automatic int i = j;
         fork
         begin
            seq_branch[i] = calc_seq_branch::type_id::create($sformatf("seq_branch%0d",i));
            seq_branch[i].num_runs = 10;
			`uvm_info(get_full_name, $sformatf("br1 start seq %0d", i), UVM_LOW)
            seq_branch[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
      end  
	   wait fork;
      
      apply_reset(3);

      foreach (seq_branch[j]) begin
         automatic int i = j;
         fork
         begin
            seq_branch[i] = calc_seq_branch::type_id::create($sformatf("seq_branch%0d",i));
            seq_branch[i].num_runs = 10;
			`uvm_info(get_full_name, $sformatf("br2 start seq %0d", i), UVM_LOW)
            seq_branch[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
         end
         join_none
      end  
	   wait fork;
     
   endtask : body
    
endclass : vseq_reset

