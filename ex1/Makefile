
diode:
	aimspice diode.spi | tee diode.sim
	@cat diode.sim | perl -ne "if(m/error/){system('cat diode.log');}"
