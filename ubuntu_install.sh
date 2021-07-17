#!/usr/bin/env bash
set -euo pipefail

cd
git clone https://github.com/wulffern/eda.git

echo "source ~/eda/bashrc" >> .bashrc

[ -d pro ] || mkdir pro
cd pro
git clone https://github.com/wulffern/dicex.git
cd dicex
pip3 install --user -r requirements.txt
