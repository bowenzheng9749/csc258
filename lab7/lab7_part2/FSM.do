vlib work

vlog -timescale 1ns/1ns part2.v

vsim control

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
force {clock} 0 0, 1 5 -r 10
force {resetn} 0 0, 1 10
force {go} 0 0, 1 10 -r 20
force {ld} 0 0, 1 10 -r 20
run 80ns