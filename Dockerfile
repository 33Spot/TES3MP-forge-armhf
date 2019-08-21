FROM arm64v8/debian:stretch

LABEL maintainer="Grim Kriegor <grimkriegor@krutt.org>"
LABEL description="A container to simplify the packaging of TES3MP for GNU/Linux (armhf version)"

ENV DEBIAN_FRONTEND noninteractive


COPY tmp/qemu-arm-static /usr/bin/qemu-arm-static



RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN sed -i "s/\#//g" /etc/apt/sources.list
RUN sed -i "/snapshot/d" /etc/apt/sources.list
RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y curl wget apt-transport-https dirmngr
#RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN cp /etc/apt/sources.list /etc/apt/sources.list_bk
RUN printf "deb http://deb.debian.org/debian/ oldstable main contrib non-free\ndeb-src http://deb.debian.org/debian/ oldstable main contrib non-free\ndeb http://deb.debian.org/debian/ oldstable-updates main contrib non-free\ndeb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free\ndeb http://deb.debian.org/debian-security oldstable/updates main\ndeb-src http://deb.debian.org/debian-security oldstable/updates main\ndeb http://ftp.debian.org/debian stretch-backports main\ndeb-src http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list
RUN printf "deb http://packages.debian.org stretch main oldstable" >> /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y install apt-file
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update \
    && apt-get -y install \
        build-essential \
        git \
        wget \
        lsb-release \
        unzip \
        cmake \
        libopenal-dev \
        libsdl2-dev \
        libunshield-dev \
        libncurses5-dev \
        libluajit-5.1-dev \
        libboost-filesystem-dev \
        libboost-thread-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        apt-transport-https

RUN git clone --depth 1 https://github.com/OpenMW/osg.git /tmp/osg \
    && cd /tmp/osg \
    && cmake . \
    && cp -a /tmp/osg/include/* /usr/include/ \
    && rm -rf /tmp/osg

RUN git config --global user.email "nwah@mail.com" \
    && git config --global user.name "N'Wah" \
    && git clone https://github.com/GrimKriegor/TES3MP-deploy.git /deploy \
    && mkdir /build

VOLUME [ "/build" ]
WORKDIR /build

ENTRYPOINT [ "/bin/bash", "/deploy/tes3mp-deploy.sh", "--script-upgrade", "--skip-pkgs", "--handle-corescripts", "--server-only", "--build-master"]
CMD [ "--install" ]
