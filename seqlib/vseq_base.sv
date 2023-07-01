class vseq_base extends uvm_sequence;
   
   calc_tb_env m_tb_env;
   calc_seq_reset seq_reset;
   calc_rst_seqr m_rst_seqr;
   
   virtual Clock_if clk_if;
   virtual Reset_if rst_if;
   
   `uvm_object_utils(vseq_base)
   
   virtual task pre_body();
      `uvm_info(get_type_name(), "Sequence started", UVM_LOW)
   
      if(!uvm_config_db#(virtual Reset_if)::get(null, get_full_name(), "rst_if", rst_if))
         `uvm_error(this.get_type_name(), {"rst_if not found in config_db"})
      if(!uvm_config_db#(virtual Clock_if)::get(null, get_full_name(), "clk_if", clk_if))
         `uvm_error(this.get_type_name(), {"clk_if not found in config_db"})
  
   endtask : pre_body
   
   function new(string name = "vseq_base");
      super.new(name);
      if(!$cast(m_tb_env, uvm_top.find("*.m_tb_env"))) begin
         `uvm_error(get_name(), "m_tb_env is not found");
      end
   endfunction : new
   
   virtual task apply_reset(int count);
      seq_reset = calc_seq_reset::type_id::create("seq_reset");
	   seq_reset.count = count;
      seq_reset.start(m_tb_env.m_tb_vseqr.m_rst_seqr);
   endtask : apply_reset

endclass : vseq_base