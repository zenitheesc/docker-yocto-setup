FROM ubuntu:20.04
# evitar interacoes pq bugam
ENV DEBIAN_FRONTEND noninteractive

# atualizar
RUN apt-get update
# instalar os pacotes nescessarios pro yocto
RUN apt-get -y install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev zstd liblz4-tool
# instalar pacotes uteis
RUN apt-get -y install sudo curl locales vim

# fix bitbake error "Your system needs to support the en_US.UTF-8 locale."
RUN locale-gen en_US.UTF-8

# non-root user pra fazer a build
RUN id build 2>/dev/null || useradd --uid 30000 --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers
USER build
WORKDIR /home/build

# poky
RUN git clone -b dunfell git://git.yoctoproject.org/poky 
WORKDIR /home/build/poky
# install pre-built buildtools tarball
RUN ./scripts/install-buildtools
# use . file ao inves de source file
RUN . /home/build/poky/buildtools/environment-setup-x86_64-pokysdk-linux

RUN git clone https://github.com/zenitheesc/meta-zenith-os.git
RUN git clone -b dunfell-5.x.y https://git.toradex.com/cgit/meta-toradex-nxp.git
RUN git clone -b dunfell git://git.yoctoproject.org/meta-freescale
RUN git clone -b dunfell https://github.com/Freescale/meta-freescale-3rdparty.git
RUN git clone -b dunfell-5.x.y git://git.toradex.com/meta-toradex-bsp-common.git

RUN . /home/build/poky/oe-init-build-env
WORKDIR /home/build/poky/build

RUN ../bitbake/bin/bitbake-layers add-layer ../meta-toradex-bsp-common
RUN ../bitbake/bin/bitbake-layers add-layer ../meta-freescale
RUN ../bitbake/bin/bitbake-layers add-layer ../meta-freescale-3rdparty/
RUN ../bitbake/bin/bitbake-layers add-layer ../meta-toradex-nxp

RUN ../bitbake/bin/bitbake-layers add-layer ../meta-zenith-os
