

plt=python3 ../py/plot.py

a2:
	${MAKE} aim TB=a2

a2vg:
	cat a2.csv|grep ",1.5"

a2dvx:
	${plt} a2.csv v2 "v(vx)"

a2vx:
	${plt} a2.csv Frequency "vm(vx)" db20

a2_bias:
	${MAKE} aim TB=a2_bias

a2bvx:
	${plt} a2_bias.csv Frequency "vm(vx)" db20

a1:
	${MAKE} aim TB=a1

a1vx:
	${plt} a1.csv Frequency "vm(vx)" db20


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

clean:
	-rm *.csv
	-rm *.log
	-rm *.sim
