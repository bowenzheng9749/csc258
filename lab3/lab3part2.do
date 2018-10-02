vlib work

vlog -timescale 1ns/1ns lab3part2.v

vsim lab3part2

log {/*}

add wave {/*}

force {SW[8]} 1

# A = 0000 (0); b = 0000 (0)
# output = 0001 (1) 

force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0
force {SW[3]} 0
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0

run 10ns

# A = 1000 (8)  B = 1000 (8)
# output = 10001 (17)

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns

# A = 1000 (8) B = 0111 (7)
# output = 10000 (16)

force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns

# A = 1111 (15) B = 1111 (15)
# output = 11111 (31)

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns

force {SW[8]} 0

# A = 1010 (10) B = 0101 
# output = 1111 (15)

force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns

# A = 1000 (8)  B = 1000 (8)
# output = 10000 (16)

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 0
force {SW[4]} 0
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns

# A = 1000 (8) B = 0111 (7)
# output = 1111 (15)

force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 10ns

# A = 1111 (15) B = 1111 (15)
# output = 11110 (30)

force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 10ns





