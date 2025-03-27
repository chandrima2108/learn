// Top-level module for APB Protocol demonstration
module apb_protocol_top(
    input clk,
    input rst_n,
    
    // APB Master Signals
    output [31:0] paddr,      // Address
    output penable,           // Enable
    output pwrite,            // Write/Read select
    output [31:0] pwdata,     // Write data
    input [31:0] prdata,      // Read data
    input pready,             // Slave ready signal
    output psel                // Select signal
);

    // Instantiate APB Master
    apb_master master (
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

    // Instantiate APB Slave
    apb_slave slave (
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

endmodule