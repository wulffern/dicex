#!/usr/bin/env python3


import numpy as np
import matplotlib.pyplot as plt

npzfile = np.load("data.npz")
vgs = npzfile['vgs']
vds = npzfile['vds']
I_D = npzfile['I_D']


print(vgs)

lI_D = np.log(I_D + 1e-5)

fig = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(vgs,vds,lI_D, rstride=1, cstride=1,
                cmap='viridis', edgecolor='none')

#ax.zaxis._set_scale('log')
ax.set_xlabel("VGS [V]")
ax.set_ylabel("VDS [V]")
ax.set_zlabel("log10(I_D) [mA]")

fig = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(vgs,vds,I_D, rstride=1, cstride=1,
                cmap='viridis', edgecolor='none')

#ax.zaxis._set_scale('log')
ax.set_xlabel("VGS [V]")
ax.set_ylabel("VDS [V]")
ax.set_zlabel("I_D [mA]")
plt.show()
