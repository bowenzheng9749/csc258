vlib work

vlog -timescale 1ns/1ns random.v

vsim random

log {/*}

add wave {/*}

force {clock} 0 0,1 10 -r 2

force {resetn} 0 0,1 20
run 200000000000ns
