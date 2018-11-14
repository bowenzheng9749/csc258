vlib work

vlog -timescale 1ns/1ns part2.v

vsim datapath

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
force {clock} 0 0, 1 5 -r 10
force {resetn} 0 0, 1 10
force {data} 0001010 0, 0010000 20
force {colour} 100
force {ld_x} 1 0, 0 20
force {ld_y} 0 0, 1 20, 0 30
force {draw} 0 0, 1 35
run 200ns