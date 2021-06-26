#!/usr/bin/env bash
set -euo pipefail

docker run -it -p 5901:5901 -e VNC_RESOLUTION=1920x1080 -e VNC_PW=ciceda  -v `pwd`/:/headless/eda wulffern/ciceda:0.2.1 bash
