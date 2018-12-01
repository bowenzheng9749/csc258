vlib work

vlog -timescale 1ns/1ns random.v

vsim random

log {/*}

add wave {/*}

force {clock} 0 0,1 5 -r 10
force {enable} 0 0, 1 25 -r 50
force {reset} 1 0,0 10
run 20000ns
