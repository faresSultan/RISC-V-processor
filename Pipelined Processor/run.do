vlib work
vlog *.v
vsim -novopt work.tb
add wave -position insertpoint sim:/tb/DUT/*
run -all