#!/usr/bin/env bash
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

sudo chown -R ciceda:ciceda .vnc
sudo chown ciceda:ciceda .


PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

export USER=ciceda
