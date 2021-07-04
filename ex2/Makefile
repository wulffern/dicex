
sim:
	aimspice nmos.cir -o csv
	aimspice nmos_vd.cir -o csv

vg:
	python3 plotvd.py nmos.csv "v(vg)"

vd:
	python3 plotvd.py nmos_vd.csv "v(vd)"

ro:
	python3 ../py/plot.py nmos.csv "v2" "v(a)"
