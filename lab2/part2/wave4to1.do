# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns mux4to1.v

# Load simulation using mux as the top level simulation module.
vsim mux4to1

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.
# SW[0] should control the output.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 0
# Run simulation for a few ns.
run 10ns

#Second test case
# Set input values using the force command, signal names need to be in {} brackets.
# SW[0] should control the output.
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 0
# Run simulation for a few ns.
run 10ns

#Third test case
# Set input values using the force command, signal names need to be in {} brackets.
# SW[1] should control the output.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 1
# Run simulation for a few ns.
run 10ns

#Fourth test case
# Set input values using the force command, signal names need to be in {} brackets.
# SW[1] should control the output.
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 1
# Run simulation for a few ns.
run 10ns


#Fifth test case
# Set input values using the force command, signal names need to be in {} brackets.
# SW[2] should control the output.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 1
force {SW[9]} 0
# Run simulation for a few ns.
run 10ns

#Sixth test case
# Set input values using the force command, signal names need to be in {} brackets.
# SW[2] should control the output.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[8]} 1
force {SW[9]} 0
# Run simulation for a few ns.
run 10ns

#Seventh test case
# Set input values using the force command, signal names need to be in {} brackets.
# SW[3] should control the output.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 1
force {SW[9]} 1
# Run simulation for a few ns.
run 10ns

#Eigth test case
# Set input values using the force command, signal names need to be in {} brackets.
# SW[3] should control the output.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
force {SW[8]} 1
force {SW[9]} 1
# Run simulation for a few ns.
run 10ns

