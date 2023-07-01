class vseq_ordering_rules extends vseq_base;
   
   calc_seq_ordering_rules seq_ordering_rules[4];
 
  `uvm_object_utils(vseq_ordering_rules)
   
   function new(string name = "vseq_ordering_rules");
      super.new(name);
   endfunction : new

   virtual task body();
      `uvm_info(get_type_name(), $sformatf("Sequence %s running", get_name()), UVM_LOW)
      
	  apply_reset(3);
	  
	  foreach (seq_ordering_rules[i]) begin
	     seq_ordering_rules[i] = calc_seq_ordering_rules::type_id::create($sformatf("seq_ordering_rules%0d",i));
	     seq_ordering_rules[i].num_runs = 100;
	     seq_ordering_rules[i].start(m_tb_env.m_tb_vseqr.m_req_seqr[i]);
      end    
   endtask : body
    
endclass : vseq_ordering_rules
