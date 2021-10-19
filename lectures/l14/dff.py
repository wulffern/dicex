#!/usr/bin/env python3

#!/usr/bin/env python3

import numpy as np
import subprocess
import matplotlib.pyplot as plt
import re




template = ""
with open("dff.cir") as fi:
    template = fi.read()


def sh(cmd, input=""):
    rst = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, input=input.encode("utf-8"))
    assert rst.returncode == 0, rst.stderr.decode("utf-8")
    return rst.stdout.decode("utf-8")


def runSim(name,t_setup,t_hold):

    tmp = template.replace("t_setup = 0","t_setup = " + str(t_setup)).replace("t_hold  = 0","t_hold = " + str(t_hold))
    with open(name + ".cir","w") as fo:
        fo.write(tmp)
    buffer = sh(f"aimspice -o csv {name}.cir && python3 ../../py/plot.py {name}.csv \"Time\" \"v(d),v(ck),v(q),v(qn)\" \"pdf\" ")


t_setup = [8,10]
t_hold = [-80,-40,0]

for t_set in t_setup:
    runSim("dff_setup_" + str(t_set),t_set*1e-12,100e-12)

for th in t_hold:
    runSim("dff_hold_" + str(th),20*1e-12,th*1e-12)
