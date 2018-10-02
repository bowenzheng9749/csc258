vlib work

vlog -timescale 1ns/1ns lab3part3.v

vsim lab3part3

log {/*}

add wave {/*}

# A = 0000 (0) B = 0000 (0)
force {SW[7:4]} 4'b0000
force {SW[3:0]} 4'b0000

force {KEY[0]} 0 0, 1 20 -repeat 40
force {KEY[1]} 0 0, 1 40 -repeat 80
force {KEY[2]} 0 0, 1 80 -repeat 160

#results
#111: 0000_0001
#110: 0000_0000
#101: 0000_0000
#100: 0000_0000
#011: 0000_0000
#010: 0000_0000

run 160ns

# A = 1111 (15) B = 0001 (1)
force {SW[7:4]} 4'b1111
force {SW[3:0]} 4'b0001

force {KEY[0]} 0 0, 1 20 -repeat 40
force {KEY[1]} 0 0, 1 40 -repeat 80
force {KEY[2]} 0 0, 1 80 -repeat 160

#results
#111: 0001_0000
#110: 0001_0000
#101: 0001_0000
#100: 0000_0000
#011: 0000_0000
#010: 0000_0000


run 160ns

