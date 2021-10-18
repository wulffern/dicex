#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math
import tikzplotlib


def plot(xname,yname,ptype=None,ax=None):

    df = pd.read_csv(fname,header=4 )
    x = df[xname]
    y = df[yname]

    #print(y)
    #- Plot

    if("logy" in ptype):
        ax.semilogy(x,y,label=yname)
    elif("ln2" in ptype):
        ax.plot(x,np.log(y)/np.log(2),label=yname)
    elif("logx" in ptype):
        ax.semilogx(x,y,label=yname)
    elif("db20" in ptype):
        ax.semilogx(x,20*np.log10(y),label="dB20(" + yname + ")")
    else:
        ax.plot(x,y,label=yname)

    ax.legend()

    if(ptype == ""):
        ax.set_ylabel(yname)
    ax.grid()


if(len(sys.argv) < 4):
    print("Usage python3 plot.py <file.csv> <x-name> <y-name,[y-name]> ")

ptype = ""
if(len(sys.argv) > 4):
    ptype = sys.argv[4]

fname = sys.argv[1]
xname = sys.argv[2]
yname = sys.argv[3]


if("," in yname):
    names = yname.split(",")


    if("same" in ptype):
        f,axes = plt.subplots(1,1)
    else:
        f,axes = plt.subplots(len(names),1,sharex=True)

    for i in range(0,len(names)):
        if("same" in ptype):
            plot(xname,names[i],ptype,ax=axes)
        else:
            plot(xname,names[i],ptype,ax=axes[i])
    plt.xlabel(xname + "(" + fname + ")")
else:
    f,axes = plt.subplots(1,1)
    plot(xname,yname,ptype,axes)

plt.tight_layout()

if("tikz" in ptype):
    tikzplotlib.save(fname.replace(".csv",".pgf"))

plt.savefig(fname.replace(".csv",".pdf"))

if("pdf" not in ptype):
    plt.show()
