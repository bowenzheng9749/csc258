vlib work

vlog -timescale 1ns/1ns lab5part3.v

vsim lab5part3

log {/*}

add wave {/*}

force {SW[2:0]} 3'b000

# enable
force {SW[3]} 0 0, 1 2

# reset_n
force {KEY[0]} 0 0, 1 2

force {KEY[1]} 1 0, 0 1, 1 2, 0 3, 1 4

force {CLOCK_50} 0 0, 1 1 -r 2

run 200000010ns