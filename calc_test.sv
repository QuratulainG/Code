class calc_test extends uvm_test;
   
   uvm_factory m_factory;
   uvm_object m_object;
   vseq_base m_sequence;
   calc_tb_env m_tb_env;
   
   `uvm_component_utils(calc_test)
   
   function new (input string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction : new
   
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	   m_tb_env = calc_tb_env::type_id::create("m_tb_env", this);
	endfunction : build_phase

   virtual task run_phase(uvm_phase phase);
      string test_seq_name;
      
      phase.raise_objection(this);

      m_factory = uvm_factory::get();
      if(!$value$plusargs("TEST_SEQ_NAME=%s", test_seq_name))begin
         `uvm_fatal("CALC_TEST", "test_seq_name not provided")	
      end
      m_object = m_factory.create_object_by_name(test_seq_name);
      $cast(m_sequence, m_object);
      m_sequence.start(m_tb_env.m_tb_vseqr);

      // drain time
      #5000;

      phase.drop_objection(this);
   endtask : run_phase
      
endclass : calc_test