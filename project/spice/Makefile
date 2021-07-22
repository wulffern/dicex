
plt=python3 ../../py/plot.py

pixSens:
	${MAKE} ngspice	 TB=pixelSensor_tb



ngspice:
	ngspice -a ${TB}.cir
