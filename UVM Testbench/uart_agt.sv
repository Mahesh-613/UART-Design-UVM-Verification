class uart_agt extends uvm_agent;
	`uvm_component_utils(uart_agt)
	uart_drv drv;
	uart_mon mon;
	uart_seqr seqr;

	function new(string name = "uart_agt", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		drv = uart_drv::type_id::create("drv",this);
		mon = uart_mon::type_id::create("mon",this);
		seqr = uart_seqr::type_id::create("seqr",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction
endclass

