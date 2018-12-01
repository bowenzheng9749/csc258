vlib work

vlog -timescale 1ns/1ns random.v

vsim rand

log {/*}

add wave {/*}

force {clock} 0 0,1 10 -r 20
force {reset} 0 0,1 10
run 200000000000ns
