#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math

eng = {
    -1 : [1e3,"m"],
    -2 : [1e3,"m"],
    -3 : [1e3,"m"],
    -4 : [1e6,"u"],
    -5 : [1e6,"u"],
    -6 : [1e6,"u"],
    -7 : [1e9,"n"],
    -8 : [1e9,"n"],
    -9 : [1e9,"n"],
    -10 : [1e12,"p"],
    -11 : [1e12,"p"],
    -12 : [1e12,"p"],
    -13 : [1e15,"f"],
    -14 : [1e15,"f"],
    -15 : [1e15,"f"]
}

if(len(sys.argv) < 4):
    print("Usage python3 plot.py <file.csv> <x-name> <y-name> ")

ptype = None
if(len(sys.argv) > 4):
    ptype = sys.argv[4]

fname = sys.argv[1]
xname = sys.argv[2]
yname = sys.argv[3]

df = pd.read_csv(fname,header=4 )

x = df[xname]
y = df[yname]

#- Resize y to m,u,p,
ymax = np.floor(np.log10(y.max()))
scale = 0
unit = ""
if(ymax in eng):
    scale = eng[ymax][0]
    unit  = eng[ymax][1]
y = y*scale

#- Plot
if(ptype == "logy"):
    plt.semilogy(x,y)
else:
    plt.plot(x,y)

plt.xlabel(xname)
plt.ylabel(yname + f"[{unit}]")
plt.grid()
plt.show()
