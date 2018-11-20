vlib work

vlog -timescale 1ns/1ns part3.v

vsim combined

log {/*}

add wave {/*}

force {go} 0 0,1 25
force {clock} 0 0,1 1 -r 2
force {resetn} 0 0,1 20
force {colour} 2#101

run 1000ns