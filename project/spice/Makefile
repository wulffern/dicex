

plt=python3 ../../py/plot.py

diode:
	${MAKE} aim TB=diode

dvb:

	${plt} diode.csv temp "v(ib),v(ib1),v(ib2),v(ib3),v(ref)" same


aim:
	-rm ${TB}.log
	-rm ${TB}.csv
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/i){system('cat ${TB}.log'); exit 1;}"
