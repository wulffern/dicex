#!/usr/bin/env python3

import numpy as np
import subprocess
import matplotlib.pyplot as plt
import re

N = 20
l_vds = np.logspace(np.log10(1e-5),np.log10(1.5),num=N)
l_vgs = np.linspace(0,1.5,N)

m_vds,m_vgs = np.meshgrid(l_vds,l_vgs)

template = ""
with open("mos.cir") as fi:
    template = fi.read()


def sh(cmd, input=""):
    rst = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, input=input.encode("utf-8"))
    assert rst.returncode == 0, rst.stderr.decode("utf-8")
    return rst.stdout.decode("utf-8")


def runSim(vds,vgs):

    tmp = template.replace("{VD}",str(vds)).replace("{VG}",str(vgs))
    with open("tmp.cir","w") as fo:
        fo.write(tmp)
    buffer = sh("aimspice tmp.cir|grep \"i(vd)\"")

    m = re.match("i\(vd\)\s+=\s+(.*)\s+A",buffer)
    I_D = 0
    if(m):
         I_D = float(m.group(1))

    return I_D



I_D = np.zeros((N,N))
for i in range(0,N):
    for j in range(0,N):
        I_D[i,j] = runSim(m_vds[i,j],m_vgs[i,j])

        print("I_D = %g VGS = %g VDS = %g"% (I_D[i,j],m_vgs[i,j],m_vds[i,j]))

#- Convert to mA
I_D = -I_D*1000

np.savez("data.npz",vgs=m_vgs,vds=m_vds,I_D=I_D)
