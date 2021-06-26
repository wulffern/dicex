
plt=python3 ../../../py/plot.py

run:
	${MAKE} aim TB=tb_nchio
	${plt} tb_nchio.csv vgate "i(vcur)"

aim:
	-rm ${TB}.log
	-rm ${TB}.csv
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/i){system('cat ${TB}.log'); exit 1;}"
