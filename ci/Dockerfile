FROM ubuntu:groovy
RUN git clone https://github.com/wulffern/dicex.git
WORKDIR dicex
RUN git pull
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/wulffern/dicex/main/ubuntu_install.sh)"
RUN source $HOME/eda/bashrc && make test
