#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math
import tikzplotlib


def plot(xname,yname,ptype=None):

    if(ptype != "same"):
        f = plt.figure()

    df = pd.read_csv(fname,header=4 )
    x = df[xname]
    y = df[yname]

    #print(y)
    #- Plot
    if(ptype == "logy"):
        plt.semilogy(x,y,label=yname)
    elif(ptype == "db20"):
        plt.semilogx(x,20*np.log10(y),label="dB20(" + yname + ")")
    else:
        plt.plot(x,y,label=yname)

    plt.legend()
    plt.xlabel(xname)
    if(ptype == None):
        plt.ylabel(yname)
    plt.grid()


if(len(sys.argv) < 4):
    print("Usage python3 plot.py <file.csv> <x-name> <y-name,[y-name]> ")

ptype = None
if(len(sys.argv) > 4):
    ptype = sys.argv[4]

fname = sys.argv[1]
xname = sys.argv[2]
yname = sys.argv[3]

if("," in yname):
    names = yname.split(",")
    for n in names:
        plot(xname,n,ptype)
else:
    plot(xname,yname,ptype)

tikzplotlib.save(fname.replace(".csv",".pgf"))
plt.savefig(fname.replace(".csv",".pdf"))
plt.show()
