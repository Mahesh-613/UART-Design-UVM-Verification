module baudrate_gen_tb;
    reg clk,rst;
    wire tx_baudtick, rx_baudtick;

    baud_rate_generator  uut(
        .clk(clk),
        .rst(rst),
        .tx_baud_tick(tx_baudtick),
	.rx_baud_tick(rx_baudtick)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("baudrate.vcd");
        $dumpvars(0,uut);

        rst = 1;
	#10;
	rst = 0;
        
        #1000_000_000;

        $finish;

    end

    initial begin
        $monitor("At time = %t, tx_baudtick = %b, rx_baudtick",$time,tx_baudtick,rx_baudtick);
    end

endmodule
