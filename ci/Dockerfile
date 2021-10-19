FROM wulffern/ciceda
WORKDIR /home/ciceda
RUN git clone https://github.com/wulffern/dicex.git
RUN git pull
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/wulffern/dicex/main/ubuntu_install.sh)"
RUN make test
