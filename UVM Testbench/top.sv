import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_intf.sv"
`include "uart_item.sv"
`include "uart_seq.sv"
`include "uart_seqr.sv"
`include "uart_drv.sv"
`include "uart_mon.sv"
`include "uart_agt.sv"
`include "uart_sbd.sv"
`include "uart_env.sv"
`include "uart_test.sv"

module tb_top;
	logic clk,rst;

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	uart_intf intf (
	       .clk(clk),
	       .rst(rst)
	       );

	top dut(
		.clk(intf.clk),
		.rst(intf.rst),
		.tx_start(intf.tx_start),
		.data_in(intf.data_in),
		.busy(intf.busy),
		.rx_done(intf.rx_done),
		.data_out(intf.data_out)
		);

	initial begin
		uvm_config_db#(virtual uart_intf)::set(null,"*","vif",intf);
		run_test("uart_test");
	end
	
	initial begin
	   rst = 1;
	   #20;
	   rst = 0;
	end
endmodule


