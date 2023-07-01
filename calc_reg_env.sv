class calc_reg_env extends uvm_env;
	calc_reg_model m_reg_model;
	calc_reg_adapter m_reg_adapter[4];
	uvm_reg_predictor#(calc_req_trans) m_reg_predictor[4]; // TODO: should not use fixed value 4
	
	`uvm_component_utils_begin(calc_reg_env)
	   `uvm_field_object(m_reg_model, UVM_DEFAULT | UVM_REFERENCE)
	   `uvm_field_sarray_object(m_reg_adapter, UVM_DEFAULT | UVM_REFERENCE)
	`uvm_component_utils_end
	
	function new(input string name, input uvm_component parent = null);
	   super.new(name, parent);
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		foreach(m_reg_predictor[i]) begin
		   m_reg_predictor[i] = uvm_reg_predictor#(calc_req_trans)::type_id::create($sformatf("m_reg_predictor%0d",i), this);
		   m_reg_adapter[i] = calc_reg_adapter::type_id::create($sformatf("m_reg_adapter%0d", i));	
	    end
		if(m_reg_model == null) begin
	       m_reg_model = calc_reg_model::type_id::create("m_reg_model");
		   m_reg_model.build();
		   m_reg_model.lock_model();
           uvm_config_db#(calc_reg_model)::set(null, "*", "m_reg_model", m_reg_model);
	    end
	endfunction : build_phase
	
	virtual function void connect_phase(uvm_phase phase);
	   super.connect_phase(phase);
	   m_reg_predictor[0].map = m_reg_model.reg_map0;
	   m_reg_predictor[1].map = m_reg_model.reg_map1;
	   m_reg_predictor[2].map = m_reg_model.reg_map2;
	   m_reg_predictor[3].map = m_reg_model.reg_map3;
	   m_reg_predictor[0].adapter = m_reg_adapter[0];
	   m_reg_predictor[1].adapter = m_reg_adapter[1];
	   m_reg_predictor[2].adapter = m_reg_adapter[2];
	   m_reg_predictor[3].adapter = m_reg_adapter[3];
	endfunction : connect_phase

endclass : calc_reg_env