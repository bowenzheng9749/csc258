vlib work

vlog -timescale 1ns/1ns lab5part2.v

vsim counter

log {/*}

add wave {/*}

force {key} 2'b00

force {enable} 1

force {reset_n} 0 0, 1 2

force {clock} 0 0, 1 1 -r 2




run 200ns
