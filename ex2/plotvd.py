#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math
import tikzplotlib

fname = sys.argv[1]
xname = sys.argv[2]

df = pd.read_csv(fname,header=4 )

x =df[xname]
gm = df["gm(m1)"]*1e3 #mS
rds = df["rds(m1)"]
i = df["id(m1)"]*1e3 #mA


plt.subplot(3,1,1)
plt.plot(x,gm)
plt.ylabel("Gm [mS]")
plt.subplot(3,1,2)
plt.semilogy(x,rds)
plt.ylabel("Rds [Ohm]")

plt.subplot(3,1,3)
plt.plot(x,i)
plt.ylabel("ID [mA]")

plt.tight_layout()

tikzplotlib.save(fname.replace(".csv",".pgf"))

plt.show()
