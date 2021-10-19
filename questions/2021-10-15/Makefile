
sim:
	aimspice -o csv comp.cir

plot:
	python3 ../../py/plot.py comp.csv v4 "v(vo),v(vramp),v(vstore),v(vs)"


wrongplot:
	python3 ../../py/plot.py comp.csv v4 "v(vp),v(vramp),v(vstore),v(vs)"
