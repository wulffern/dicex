#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math
import tikzplotlib
import os

buffer = ""
with open("rosc.cir") as fi:
    for line in fi:
        if(line.startswith("VDD")):
            buffer += "VDD VDD VSS dc {vdd}\n"
        else:
            buffer += line

fon = "rosc_vdd"
vdds = np.linspace(0.3,1.5,num=20)

os.system(f"touch {fon}.yaml")
for vdd in vdds:
    cir = buffer.replace("{vdd}",str(vdd))
    with open(f"{fon}.cir", "w") as fo:
        fo.write(cir)
    os.system(f"aimspice -o csv {fon}.cir")
    os.system(f" echo '{vdd}': >> {fon}.yaml")
    os.system(f"python3 freq.py {fon}.csv 'v(a1)' 4.1e-9 >> {fon}.yaml")
