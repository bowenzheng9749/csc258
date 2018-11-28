vlib work

vlog -timescale 1ns/1ns try.v

vsim combined

log {/*}

add wave {/*}

force {go} 0 0,1 40 ,0 80
force {clock} 0 0,1 1 -r 2
force {sclock} 0 0, 1 100 -r 200
force {resetn} 0 0,1 20
run 200000ns
