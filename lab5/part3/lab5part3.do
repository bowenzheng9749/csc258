vlib work

vlog -timescale 1ns/1ns lab5part3.v

vsim morseencoder

log {/*}

add wave {/*}

force {key[2: 0]} 2#110
force {start} 1 0, 0 20
force {clk} 0 0, 1 10 -r 20
force {asr_n} 1 0, 0 1, 1 2
run 1800ns