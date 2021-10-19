
sim:
	aimspice nmos.cir -o csv
	aimspice nmos_vd.cir -o csv

vg:
	python3 plotvd.py nmos.csv "v(vg)" ${OPT}

vd:
	python3 plotvd.py nmos_vd.csv "v(vd)" ${OPT}

ro:
	python3 ../py/plot.py nmos.csv "v2" "v(a)" ${OPT}


test: sim ro
