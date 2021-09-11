#!/usr/bin/env python3

import numpy as np
import sys
import matplotlib.pyplot as plt

stop = 5*255

def readCsv(fname):
    ll = list()
    for i in range(0,8):
        ll.append(list())
    i =0
    line  = 0
    with open(fname,"r") as fg:
        for l in fg:
            i = 0
            l = l.strip()
            for c in l:
                ll[i].append(int(c))
                i +=1
            line+=1
            if(line > stop):
                break
    return ll

fname = sys.argv[1]
ll= readCsv(fname)


for i in range(0,8):
    l = ll[i]
    plt.subplot(8,1,i+1)
    plt.ylabel("B" + str(7-i))
    plt.plot(l)
    if(i==0):
        plt.title(fname.replace(".csv",""))



plt.savefig(fname.replace(".csv",".pdf"))
plt.show()
