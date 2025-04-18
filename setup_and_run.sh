#!/bin/bash

# Install dependencies for APB Protocol simulation
sudo apt update
sudo apt install -y iverilog gtkwave

# Run the Makefile to compile and simulate
make

# Open the waveform in GTKWave
make waveform