// Testbench for APB Protocol
`timescale 1ns/1ps

module apb_protocol_tb;
    // Signals
    reg clk;
    reg rst_n;
    wire [31:0] paddr;
    wire penable;
    wire pwrite;
    wire [31:0] pwdata;
    wire [31:0] prdata;
    wire pready;
    wire psel;

    // Instantiate Top Module
    apb_protocol_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .paddr(paddr),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .prdata(prdata),
        .pready(pready),
        .psel(psel)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Testbench Stimulus
    initial begin
        // Initialize Signals
        clk = 0;
        rst_n = 0;

        // Reset Sequence
        #10 rst_n = 1;

        // Optional: Add more test scenarios
        #200 $finish;
    end

    // Simulation Output
    initial begin
        $monitor("Time=%0t paddr=%h pwrite=%b pwdata=%h prdata=%h pready=%b psel=%b", 
                 $time, paddr, pwrite, pwdata, prdata, pready, psel);
        
        // VCD Dump for waveform
        $dumpfile("apb_protocol_tb.vcd");
        $dumpvars(0, apb_protocol_tb);
    end
endmodule