vlib work
vlog -timescale 1ns/1ns lab5part1.v

vsim lab5part1

log {/*}

add wave {/*}

#enable
force {SW[1]} 1

#clk
force {KEY[0]} 0 0, 1 10 -r 20

#clear_b
force {SW[0]} 1 0, 0 5, 1 10

run 200 ns