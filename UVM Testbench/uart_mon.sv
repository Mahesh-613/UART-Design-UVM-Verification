class uart_mon extends uvm_monitor;
	`uvm_component_utils(uart_mon)

	virtual uart_intf vif;

	uvm_analysis_port#(uart_item) ap;

	function new(string name = "uart_mon", uvm_component parent);
		super.new(name,parent);
		ap = new("ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual uart_intf)::get(this,"","vif",vif)) begin
			`uvm_fatal("MONITOR","Interface Not Found")
		end
	endfunction

	task run_phase(uvm_phase phase);
		uart_item item;
		logic [7:0] temp;
		forever begin
			
			item = uart_item::type_id::create("item");
        /*   @(vif.mon_cb.tx_start)begin
			item.tx_start 	= vif.mon_cb.tx_start;
			temp            = vif.mon_cb.data_in;
			item.busy    	= vif.mon_cb.busy;
			end
		*/
			@(negedge vif.mon_cb.rx_done) begin
			item.data_in 	= vif.mon_cb.data_in;
			item.rx_done 	= vif.mon_cb.rx_done;
			item.data_out 	= vif.mon_cb.data_out;
			item.tx_start 	= vif.mon_cb.tx_start;
			//temp            = vif.mon_cb.data_in;
			item.busy    	= vif.mon_cb.busy;
			end

			`uvm_info("MONITOR","Received Transaction",UVM_MEDIUM)
			item.print();
			ap.write(item);
		end
	endtask
endclass

