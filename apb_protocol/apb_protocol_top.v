// Top-level module for APB Protocol demonstration
module apb_protocol_top (
    input wire clk,
    input wire rst_n,
    
    // APB Master Signals
    output wire [31:0] paddr,      // Address
    output wire penable,           // Enable
    output wire pwrite,            // Write/Read select
    output wire [31:0] pwdata,     // Write data
    input wire [31:0] prdata,      // Read data
    input wire pready,             // Slave ready signal
    output wire psel                // Select signal
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