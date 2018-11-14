vlib work

vlog -timescale 1ns/1ns ram32x4.v

vsim -L altera_mf_ver ram32x4

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
force {clock} 0 0, 1 5 -r 10
force {address} 00000 0, 00001 11, 00010 21, 00011 31 -r 40
force {data} 0001 0, 0010 11, 0011 21, 0100 31, 0101 41, 0110 51, 0111 61, 1000 71
force {wren} 1 0, 0 40
run 100ps
