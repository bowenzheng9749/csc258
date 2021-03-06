vlib work

vlog -timescale 1ns/1ns sequence_detector.v

vsim sequence_detector

log {/*}
add wave {/*}

# Synchronous active low resetn
force {SW[0]} 0 0, 1 15

# input w
force {SW[1]} 0 0, 1 15, 0 110, 1 130, 0 150

# clock signal
force {KEY[0]} 0 0, 1 10 -r 20
run 200ns