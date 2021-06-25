
diode:
	aimspice diode.cir | tee diode.sim
	@cat diode.sim | perl -ne "if(m/error/){system('cat diode.log');}"
