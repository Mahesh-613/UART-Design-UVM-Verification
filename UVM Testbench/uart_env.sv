class uart_env extends uvm_env;
	`uvm_component_utils(uart_env)

	uart_agt agt;
	uart_sbd sbd;

	function new(string name = "uart_env", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt = uart_agt::type_id::create("agt",this);
		sbd = uart_sbd::type_id::create("sbd",this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Monitor -> Scoreboard
        agt.mon.ap.connect(sbd.exp_export);

    endfunction
endclass
