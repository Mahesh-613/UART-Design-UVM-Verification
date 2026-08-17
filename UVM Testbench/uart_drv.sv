class uart_drv extends uvm_driver#(uart_item);
	`uvm_component_utils(uart_drv)
	
	virtual uart_intf vif;

	function new(string name = "uart_drv",uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual uart_intf)::get(this,"","vif",vif))
			`uvm_fatal("DRV","Interface Not Found")
	endfunction
       
	task run_phase(uvm_phase phase);
		uart_item req;

		forever begin
			seq_item_port.get_next_item(req);
			
			@(posedge vif.drv_cb);
			vif.drv_cb.tx_start <= 1'b1;
			vif.drv_cb.data_in <= req.data_in;

			@(posedge vif.drv_cb);
			vif.drv_cb.tx_start <= 1'b0;
			
			wait(vif.busy == 1'b1);
			wait(vif.busy == 1'b0);
		//	@(posedge vif.drv_cb);

			seq_item_port.item_done();
		end
	endtask
endclass



