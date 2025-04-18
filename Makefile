# Makefile for APB Protocol Simulation

# Compiler and tools
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Source files
SRC = apb_protocol/apb_master.v \
      apb_protocol/apb_slave.v \
      apb_protocol/apb_protocol_top.v \
      apb_protocol/apb_protocol_tb.v

# Output files
OUT = apb_protocol_tb.vvp
WAVE = dump.vcd

# Default target
all: simulate

# Compile the Verilog files
compile:
	$(IVERILOG) -o $(OUT) $(SRC)

# Run the simulation
simulate: compile
	$(VVP) $(OUT)

# View the waveform
waveform: $(WAVE)
	$(GTKWAVE) $(WAVE)

# Clean up generated files
clean:
	rm -f $(OUT) $(WAVE)

.PHONY: all compile simulate waveform clean