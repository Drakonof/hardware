transcript on
vlib work
vlog -sv ../rtl/sc_simple_dual_ram.sv
vlog -sv sc_simple_dual_ram_tb.sv
vsim -t 100ns -voptargs="+acc" sc_simple_dual_ram_tb
add wave /sc_simple_dual_ram_tb/clk
add wave /sc_simple_dual_ram_tb/write_enable
add wave /sc_simple_dual_ram_tb/write_valid
add wave /sc_simple_dual_ram_tb/write_address
add wave /sc_simple_dual_ram_tb/write_data
add wave /sc_simple_dual_ram_tb/read_enable
add wave /sc_simple_dual_ram_tb/read_valid
add wave /sc_simple_dual_ram_tb/read_address
add wave /sc_simple_dual_ram_tb/read_data
configure wave -timelineunits us
run -all
wave zoom full
