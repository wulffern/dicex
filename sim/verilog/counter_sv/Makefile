
run:
	iverilog  -g2012 -o my_design -c counter.fl
	vvp -n my_design

run_netlist:
	iverilog  -g2012 -o my_design_netlist -c counter_netlist.fl
	vvp -n my_design_netlist

synth:
	yosys counter.ys
