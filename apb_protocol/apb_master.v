// APB Master Module
module apb_master(
    input clk,
    input rst_n,
    
    // APB Signals
    output reg [31:0] paddr,
    output reg penable,
    output reg pwrite,
    output reg [31:0] pwdata,
    input [31:0] prdata,
    input pready,
    output reg psel
);

    // State encoding using standard Verilog
    reg [1:0] current_state;
    reg [1:0] next_state;

    // State definitions
    parameter IDLE   = 2'b00;
    parameter SETUP  = 2'b01;
    parameter ACCESS = 2'b10;

    // Registers for transaction
    reg [31:0] data_to_write;
    reg [31:0] read_data;

    // State Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            paddr <= 32'h0;
            penable <= 1'b0;
            pwrite <= 1'b0;
            psel <= 1'b0;
            pwdata <= 32'h0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                next_state = SETUP;
                paddr = 32'h1000;  // Example address
                pwrite = 1'b1;     // Write operation
                data_to_write = 32'hA5A5A5A5;  // Example data
                psel = 1'b1;
                penable = 1'b0;
            end

            SETUP: begin
                next_state = ACCESS;
                penable = 1'b1;
                pwdata = data_to_write;
            end

            ACCESS: begin
                if (pready) begin
                    // For read, capture data
                    if (!pwrite) begin
                        read_data = prdata;
                    end
                    
                    // Return to IDLE
                    next_state = IDLE;
                    psel = 1'b0;
                    penable = 1'b0;
                end else begin
                    // Wait for slave
                    next_state = ACCESS;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule