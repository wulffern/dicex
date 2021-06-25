#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys


if(len(sys.argv) < 4):
    print("Usage python3 plot.py <file.csv> <x-name> <y-name> ")

ptype = None
if(len(sys.argv) > 4):
    ptype = sys.argv[4]

fname = sys.argv[1]
xname = sys.argv[2]
yname = sys.argv[3]

df = pd.read_csv(fname,header=4 )

if(ptype == "logy"):
    plt.semilogy(df[xname],df[yname])
else:
    plt.plot(df[xname],df[yname])

plt.xlabel(xname)
plt.ylabel(yname)
plt.show()
