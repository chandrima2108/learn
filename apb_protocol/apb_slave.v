// APB Slave Module
module apb_slave (
    input wire clk,
    input wire rst_n,
    
    // APB Signals
    input wire [31:0] paddr,
    input wire penable,
    input wire pwrite,
    input wire [31:0] pwdata,
    output reg [31:0] prdata,
    output reg pready,
    input wire psel
);

    // Internal Memory for Slave
    reg [31:0] slave_memory [0:255];
    
    // State Machine for Slave Response
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        SETUP = 2'b01,
        ACCESS = 2'b10
    } slave_state_t;

    slave_state_t current_state, next_state;

    // State Register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            prdata <= 32'h0;
            pready <= 1'b0;
            
            // Initialize memory
            for (int i = 0; i < 256; i++) begin
                slave_memory[i] <= 32'h0;
            end
        end else begin
            current_state <= next_state;
        end
    end

    // Next State and Output Logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (psel && !penable) begin
                    next_state = SETUP;
                    pready = 1'b0;
                end else begin
                    next_state = IDLE;
                    pready = 1'b0;
                end
            end

            SETUP: begin
                next_state = ACCESS;
                pready = 1'b0;
            end

            ACCESS: begin
                next_state = IDLE;
                pready = 1'b1;

                // Write Operation
                if (pwrite) begin
                    slave_memory[paddr[9:2]] = pwdata;
                end
                
                // Read Operation
                if (!pwrite) begin
                    prdata = slave_memory[paddr[9:2]];
                end
            end

            default: begin
                next_state = IDLE;
                pready = 1'b0;
            end
        endcase
    end

endmodule