vlib work

vlog -timescale 1ns/1ns try.v

vsim combined

log {/*}

add wave {/*}

force {go} 0 0,1 40
force {clock} 0 0,1 5 -r 10
force {sclock} 0 0, 1 10 -r 20
force {reset_n} 0 0,1 20
run 200000ns
