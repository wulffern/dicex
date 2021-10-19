

plt=python3 ../py/plot.py



diode:
	${MAKE} aim TB=diode


diode_rsweep:
	${MAKE} aim TB=diode_rsweep
	${plt} diode_rsweep.csv v1 "i(v2)" ${OPT}

diode_sweep:
	${MAKE} aim TB=diode_sweep
	${plt} diode_sweep.csv v1 "i(v2)" "logy${OPT}"

diode_source:
	${MAKE} aim TB=diode_source
	 ${plt} diode_source.csv v1 "v(vd)" ${OPT}

aim:
	-rm ${TB}.log
	-rm ${TB}.csv
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/i){system('cat ${TB}.log'); exit 1;}"

test: diode diode_rsweep diode_sweep dioude_source
