

run:
	iverilog  -g2012 -o bcharger.vvp -c bcharger.fl
	vvp -n bcharger.vvp

run_netlist:
	iverilog  -g2012 -o bcharger_netlist.vvp -c bcharger_netlist.fl
	vvp -n bcharger_netlist.vpp

synth:
	yosys bcharger.ys
	dot bcharger_synth.dot -Tpdf -o bcharger_synth.pdf


dot:
	dot -Tpdf bcharger.dot -o bcharger.pdf
