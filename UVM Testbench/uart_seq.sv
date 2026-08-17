class uart_seq extends uvm_sequence;
	`uvm_object_utils(uart_seq)

	function new (string name = "uart_seq");
		super.new(name);
	endfunction

	task body();
		uart_item req;
		repeat(10) begin
			req = uart_item::type_id::create("req");
			start_item(req);
			assert(req.randomize());
			finish_item(req);
		end
	endtask
endclass	

