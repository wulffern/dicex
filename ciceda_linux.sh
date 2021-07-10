#!/usr/bin/env bash
set -euo pipefail

docker run --rm -it -p 5900:5900 -v `pwd`:/home/ciceda -i wulffern/ciceda:ubuntu_latest bash -l
