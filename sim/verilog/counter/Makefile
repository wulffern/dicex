
run:
	iverilog  -g2012 -o my_design -c counter.fl
	vvp -n my_design

rungray:
	iverilog  -g2012 -o my_gray_design -c graycounter.fl
	vvp -n my_gray_design

synth:
	yosys counter.ys
