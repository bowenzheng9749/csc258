vlib work

vlog -timescale 1ns/1ns lab3part1.v

vsim lab3part1

log{/*}

add wave {/*}

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0

force {SW[7]} 0 0 ns, 1 20 ns -repeat 40
force {SW[8]} 0 0 ns, 1 40 ns -repeat 80
force {SW[9]} 0 0 ns, 1 80 ns -repeat 160

run 160ns;