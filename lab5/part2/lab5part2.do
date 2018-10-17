vlib work

vlog -timescale 1ns/1ps lab5part2.v

vsim counter

log {/*}

add wave {/*}

force {key} 2'b01

force {enable} 1

force {reset_n} 0 0ps, 1 3ps

force {clock} 0 0ps, 1 1ps -r 2ps




run 1000ns
