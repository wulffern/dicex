

plt=python3 ../py/plot.py

cm:
	${MAKE} aim TB=cm

pltro:
	${plt} cm.csv Frequency "vm(ro1),vm(ro2),vm(ro3)" same

pltvg:
	${plt} cm.csv v2 "v(vg1),v(vg2),v(vg3),v(vg4)" same

pltvs:
	${plt} cm.csv v2 "v(vs1),v(vs2),v(vs3),v(vs4)" same

pltid:
	${plt} cm.csv v2 "i(vd1),i(vd2),i(vd3)" same


aim:
	-rm ${TB}.log
	-rm ${TB}.csv
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/i){system('cat ${TB}.log'); exit 1;}"
