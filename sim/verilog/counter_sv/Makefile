
run:
	iverilog  -g2012 -o my_design -c counter.fl
	vvp -n my_design

run_netlist:
	iverilog  -g2012 -o my_design_netlist -c counter_netlist.fl
	vvp -n my_design_netlist

synth:
	yosys counter.ys

spng:
	yosys counter_netlist.ys
	dot counter.dot -Tpng > counter.png
