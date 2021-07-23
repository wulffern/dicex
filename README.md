# dicex (Design of Integrated Circuits Examples)

Getting started with SPICE and verilog can be a daunting task. Companies that
make integrated circuits spend millions on Electronic Design Automation (EDA)
tools, and even then, the truth is, they are not great. 

So, expecting open source EDA tools to be a polished, easy to use, easy to learn
tools is too much to ask.

Luckliy, at the beginning of the integrated circuit journey we don't need the
full blown commercial tools. At the beginning, we need to understand the
principles of SPICE, Verilog, how to write the files, how to run the
simulations, and how to view the results.

The difference between open source EDA tools and the commercial tools is that it's
easier to make complex systems with the commercial tools, and believe me, ICs are very complex.

For now though, let's focus on the transistors, resistor,  and the
building blocks for digital circuits, the digital gates.

# I have a Ubuntu Linux 20
If you're an NTNU student, then you can ssh to login.stud.ntnu.no and run

``` sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/wulffern/dicex/main/ubuntu_install.sh)"
```

For information on login.stud.ntnu.no see https://innsida.ntnu.no/wiki/-/wiki/English/ssh


# I don't have Ubuntu Linux 20

- Install docker from [docker.com](http://docker.com)
- Install git from [git-scm.com](https://git-scm.com/downloadsm)
- Install TigerVNC from [tigervnc.org](https://tigervnc.org)

Open a terminal (mac, linux) or powershell (windows).

Navigate to where you want your files.

``` sh
git clone https://github.com/wulffern/dicex
cd dicex

```
  
On mac

``` sh
./ciceda_mac.sh
```

On windows

``` sh
./ciceda_windows.bat
```


On linux
``` sh
./ciceda_mac.sh
```


Start vncserver if you want GUI

``` sh
./vncserver
```

Open TigerVNC, connect to *localhost:5900*

For a demo, see [dicex and ciceda](https://www.youtube.com/watch?v=SpHw1MB3fus)


If you're wondering how ciceda works, then look at [https://github.com/wulffern/ciceda](https://github.com/wulffern/ciceda)


# SPICE

The folders called ex1 etc are related to the course TFE4152 Design of
integrated circuits 

There are a few examples in spice/, for example 
``` sh
cd sim/spice/NCHIO
make
```
# Verilog
Examples for verilog are in ~/sim/verilog, for example
``` sh
cd sim/verilog/
```
 
Start waveform viewer
``` sh
gtkwave &
```

Run simulation
``` sh
make
```

In GTKWave, File -> Open New Tab. Find counter/test.vcd


# Support
I would try carsten@ntnu.no, however, I get about 100 emails per day, so my
response rate is not great. 



