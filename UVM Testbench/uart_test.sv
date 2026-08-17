class uart_test extends uvm_test;
	`uvm_component_utils(uart_test)
	uart_env env;

	function new(string name = "uart_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = uart_env::type_id::create("env",this);
	endfunction

	task run_phase(uvm_phase phase);
		uart_seq seq;
		phase.raise_objection(this);
		seq = uart_seq::type_id::create("seq");
		seq.start(env.agt.seqr);
		#100;
		phase.drop_objection(this);
	endtask

endclass

