

plt=python3 ../py/plot.py

mos:
	${MAKE} aim TB=mos

rosc:
	${MAKE} aim TB=rosc


plta:
	${plt} rosc.csv Time "v(a1),v(a2),v(pwrup)" "same${OPT}"


freq:
	python3 freq.py rosc.csv "v(a1)" 4.1e-9

aim:
	-rm ${TB}.log
	-rm ${TB}.csv
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/i){system('cat ${TB}.log'); exit 1;}"

vdds:
	#-rm rosc_vdd.yaml
	#python3 vddsweep.py
	python3 vddplot.py

clean:
	-rm *.csv
	-rm *.log
	-rm *.sim

test: mos rosc plta freq
