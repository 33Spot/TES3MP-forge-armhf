FROM arm64v8/debian:buster

LABEL maintainer="Grim Kriegor <grimkriegor@krutt.org>"
LABEL description="A container to simplify the packaging of TES3MP for GNU/Linux (armhf version)"

ENV DEBIAN_FRONTEND noninteractive


COPY tmp/qemu-arm-static /usr/bin/qemu-arm-static



RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN sed -i "s/\#//g" /etc/apt/sources.list
RUN sed -i "/snapshot/d" /etc/apt/sources.list
RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

RUN apt-get update
RUN apt-get install -y curl wget apt-transport-https dirmngr wget
RUN apt-get install -y gtk2.0
RUN apt-get install -y build-essential libgtk2.0-dev
RUN apt-get install -y libcairo2-dev libpoppler-glib-dev librsvg2-dev libgtkglextmm-x11-1.2-dev
RUN apt-get install -y libjpeg-dev libpng-dev libtiff-dev
RUN apt-get install -y dcmtk libsdl2-dev
RUN apt-get install -y libopenscenegraph-dev
#libjasper-dev openssl-dev
RUN apt-get install -y  libxml2 libgdal-dev libgles2-mesa-dev libfreetype6-dev libjpeg-dev fltk1.3-dev libgstreamer-plugins-base1.0-dev libgdal-dev libsdl2-dev libsdl1.2-dev libwxgtk3.0-dev libtiff-dev
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal
#RUN pip install GDAL
#RUN apt-get install -y gstreamer*


#RUN wget https://raw.githubusercontent.com/commontk/CTK/master/Utilities/CMake/FindDCMTK.cmake


#RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
#RUN cp /etc/apt/sources.list /etc/apt/sources.list_bk
#RUN printf "deb http://deb.debian.org/debian/ oldstable main contrib non-free\ndeb-src http://deb.debian.org/debian/ oldstable main contrib non-free\ndeb http://deb.debian.org/debian/ oldstable-updates main contrib non-free\ndeb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free\ndeb http://deb.debian.org/debian-security oldstable/updates main\ndeb-src http://deb.debian.org/debian-security oldstable/updates main\ndeb http://ftp.debian.org/debian stretch-backports main\ndeb-src http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list
#RUN printf "deb http://packages.debian.org stretch main oldstable" > /etc/apt/sources.list
#RUN printf "deb http://deb.debian.org/debian stretch main\ndeb-src http://deb.debian.org/debian stretch main\n\ndeb http://deb.debian.org/debian-security/ stretch/updates main\ndeb-src http://deb.debian.org/debian-security/ stretch/updates main\n\ndeb http://deb.debian.org/debian stretch-updates main\ndeb-src http://deb.debian.org/debian stretch-updates main\n" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y install apt-file
RUN apt-get update

RUN apt-get update \
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

#RUN git clone https://github.com/openthread/openthread \
#&& cd openthread \
#&& ./bootstrap \
#&& ./configure \
#&& make \
#&& make install

#RUN git clone --depth 1 https://github.com/OpenMW/osg.git /tmp/osg \
#    && cd /tmp/osg \
#    && cmake . \
#    && cp -a /tmp/osg/include/* /usr/include/ \
#    && rm -rf /tmp/osg
RUN cd ~
RUN git config --global user.email "insygnis@mail.com" \
    && git config --global user.name "33Spot" \
    && git clone https://github.com/GrimKriegor/TES3MP-deploy.git /deploy \
    && mkdir /build

VOLUME [ "/build" ]
WORKDIR /build
#"PATH=/usr/local/bin:$PATH LD_LIBRARY_PATH=/usr/local/aarch64-linux-gnu/lib:/usr/local/lib:/usr/local/lib64", 
ENTRYPOINT [ "/bin/bash", "./deploy/tes3mp-deploy.sh", "--script-upgrade", "--skip-pkgs", "--handle-corescripts", "--server-only", "--build-master"]
CMD [ "--install" ]
