vlib work
vlog -incr -sv -work work rtl/*.sv
vlog -incr -sv -work work tb/*.sv
vsim -voptargs=+acc work.top_tb
add wave -r /*
run -all