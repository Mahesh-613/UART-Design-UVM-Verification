class uart_item extends uvm_sequence_item;
	bit clk,rst,tx_start;
	rand bit[7:0] data_in;
	bit busy,rx_done;
	bit [7:0] data_out;

	`uvm_object_utils_begin(uart_item)

	`uvm_field_int(clk,UVM_ALL_ON)
	`uvm_field_int(rst,UVM_ALL_ON)
	`uvm_field_int(tx_start,UVM_ALL_ON)
	`uvm_field_int(data_in,UVM_ALL_ON)
	`uvm_field_int(busy,UVM_ALL_ON)
	`uvm_field_int(rx_done,UVM_ALL_ON)
	`uvm_field_int(data_out,UVM_ALL_ON)
	
	`uvm_object_utils_end

	function new(string name = "uart_item");
		super.new(name);
	endfunction
endclass
