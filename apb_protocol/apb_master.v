// APB Master Module
module apb_master (
    input wire clk,
    input wire rst_n,
    
    // APB Signals
    output reg [31:0] paddr,
    output reg penable,
    output reg pwrite,
    output reg [31:0] pwdata,
    input wire [31:0] prdata,
    input wire pready,
    output reg psel
);

    // APB State Machine States
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        SETUP = 2'b01,
        ACCESS = 2'b10
    } apb_state_t;

    // Internal Signals
    apb_state_t current_state, next_state;
    reg [31:0] data_to_write;
    reg [31:0] read_data;

    // State Register
    always_ff @(posedge clk or negedge rst_n) begin
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

    // Next State and Output Logic
    always_comb begin
        case (current_state)
            IDLE: begin
                // Initiate a write transaction
                next_state = SETUP;
                paddr = 32'h1000;  // Example address
                pwrite = 1'b1;     // Write operation
                data_to_write = 32'hA5A5A5A5;  // Example data
                psel = 1'b1;
                penable = 1'b0;
            end

            SETUP: begin
                // Prepare for access phase
                next_state = ACCESS;
                penable = 1'b1;
                pwdata = data_to_write;
            end

            ACCESS: begin
                // Check if slave is ready
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