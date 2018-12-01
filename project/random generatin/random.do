vlib work

vlog -timescale 1ns/1ns random.v

vsim rand

log {/*}

add wave {/*}

force {clock} 0 0,1 5 -r 10
force {reset} 1 0,0 10, 1 20
run 20000ns
