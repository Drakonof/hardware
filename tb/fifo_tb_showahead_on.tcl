transcript on
vlib work
vlog C:/intelFPGA_lite/18.1/quartus/eda/sim_lib/altera_mf.v
vlog -sv ../rtl/fifo.sv
vlog -sv fifo_tb.sv
vsim -t 100ns -voptargs="+acc" fifo_tb
vsim -g SHOWAHEAD_MODE="ON"
add wave /fifo_tb/clk
add wave /fifo_tb/srst
add wave /fifo_tb/data
add wave /fifo_tb/wrreq
add wave /fifo_tb/rdreq
add wave /fifo_tb/full
add wave /fifo_tb/sc_full
add wave /fifo_tb/empty
add wave /fifo_tb/sc_empty
add wave /fifo_tb/usedw
add wave /fifo_tb/sc_usedw
add wave /fifo_tb/q
add wave /fifo_tb/sc_q
configure wave -timelineunits us
run -all
wave zoom full
