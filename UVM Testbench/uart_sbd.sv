class uart_sbd extends uvm_scoreboard;
	`uvm_component_utils(uart_sbd)
	
  // TLM Analysis Exports to receive data from monitors
  uvm_analysis_export #(uart_item) exp_export;

  // TLM FIFOs to store incoming transactions until they can be compared
  uvm_tlm_analysis_fifo #(uart_item) exp_fifo;

  // Statistics counters
  int match_count;
  int mismatch_count;

  // Constructor
  function new(string name = "uart_sbd", uvm_component parent);
    super.new(name, parent);
    match_count = 0;
    mismatch_count = 0;
  endfunction

  // Build Phase: Instantiate the exports and FIFOs
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    exp_export = new("exp_export", this);
    exp_fifo   = new("exp_fifo", this);
    
  endfunction

  // Connect Phase: Connect the exports to the internal FIFOs
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    exp_export.connect(exp_fifo.analysis_export);
  endfunction

  // Run Phase: Continuously fetch and compare transactions
  virtual task run_phase(uvm_phase phase);
    uart_item tr;
    uart_item prev_tr;
    
    super.run_phase(phase);

    forever begin
      
      exp_fifo.get(tr);
      
      if(prev_tr != null)begin
        if (prev_tr.data_in == tr.data_out) begin
          `uvm_info("SCBD_MATCH",$sformatf("Match! Expected: %0h, Actual: %0h",prev_tr.data_in,tr.data_out), UVM_LOW)
          match_count++;
        end else begin
          `uvm_error("SCBD_MISMATCH",$sformatf("Mismatch! Expected: %0h, Actual: %0h",prev_tr.data_in, tr.data_out))
          mismatch_count++;
        end
        
      end 
      $cast(prev_tr,tr.clone());
    end
  endtask

//check for proper tx_start signal is feed into dut.(checked and corrected)
//drv is waiting for busy signal but i think drv cannot access the dut output verify that(verified and now driver is synchronised) 
//


// Report Phase: Print final statistics at the end of the simulation
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCBD_REPORT", "========================================", UVM_NONE)
    `uvm_info("SCBD_REPORT", "          UART SCOREBOARD RESULTS       ", UVM_NONE)
    `uvm_info("SCBD_REPORT", "========================================", UVM_NONE)
    `uvm_info("SCBD_REPORT", $sformatf("Total Test Cases Passed : %0d", match_count), UVM_NONE)
    `uvm_info("SCBD_REPORT", $sformatf("Total Test Cases Failed : %0d", mismatch_count), UVM_NONE)
    `uvm_info("SCBD_REPORT", "========================================", UVM_NONE)
    
    if (mismatch_count > 0) begin
      `uvm_error("SCBD_FAIL", "Test Failed: Data mismatches found.")
    end else if (match_count == 0) begin
      `uvm_warning("SCBD_EMPTY", "Test Warning: No data was compared.")
    end else begin
      `uvm_info("SCBD_PASS", "Test Passed: All data matched perfectly.", UVM_NONE)
    end
  endfunction

endclass
