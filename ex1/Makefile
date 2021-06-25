
aim:
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/){system('cat ${TB}.log'); exit 1;}"

diode:
	${MAKE} TB=diode


diode_rsweep:
	${MAKE} TB=diode_rsweep
	python3 plot.py diode_rsweep.csv v1 "i(v2)"

diode_sweep:
	${MAKE} TB=diode_sweep
	 python3 plot.py diode_sweep.csv v1 "i(v2)" logy
