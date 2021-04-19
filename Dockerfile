FROM ubuntu:20.04
LABEL Maintainer="JGV"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get install -y apt-utils
RUN apt-get install -y \
    build-essential \
    git \
    wget \
    subversion \
    cmake \
    swig3.0 \
    libgtk2.0-dev \
    libboost-all-dev \
    libglew-dev \
    libglm-dev \
    freeglut3-dev \ 
    libcairo2-dev \
    python-dev \
    python3-dev \
    ipython3 \
    libcurl4-openssl-dev \
    liboce-ocaf-dev \ 
    libssl-dev \
    bison \
    dbus \
    flex \
    curl \
    wget \
    coreutils \
    python3-pip \
    apt-utils \
    libgtk-3-dev \
    libnotify4 libsdl2-2.0-0 gettext libwxgtk-media3.0-gtk3-0v5 libwxgtk3.0-gtk3-dev python-wxgtk3.0-dev python3-wxgtk4.0 python3-wxgtk-webview4.0 python3-wxgtk-media4.0


WORKDIR /tmp
RUN git clone https://gitlab.com/kicad/code/kicad.git
WORKDIR ./kicad
#RUN git checkout tags/5.1.9
WORKDIR ./scripting/build_tools
RUN chmod +x get_libngspice_so.sh
RUN MAKE='make -j 20' ./get_libngspice_so.sh
RUN ./get_libngspice_so.sh install
RUN ldconfig

#RUN ln -sf /usr/bin/wx-config /usr/bin/wx-config-gtk3

WORKDIR /tmp/kicad
RUN cmake -DKICAD_SCRIPTING_ACTION_MENU=ON -DKICAD_SCRIPTING_PYTHON3=ON -DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON .
RUN make -j 20 && make install
RUN ldconfig

WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-symbols.git
WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-footprints.git
WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-packages3d.git
WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-templates.git

WORKDIR /tmp
RUN mkdir -p /usr/share/kicad/modules/packages3d/
RUN cp /usr/local/share/kicad/template/kicad.kicad_pro /tmp/kicad-templates
RUN mkdir /usr/share/kicad/plugins
RUN ln -s /tmp/kicad-symbols /usr/share/kicad/library
RUN ln -s /tmp/kicad-footprints /usr/share/kicad/modules
RUN ln -s /tmp/kicad-packages3d /tmp/kicad-footprints/packages3d
RUN ln -s /tmp/kicad-templates /usr/share/kicad/templates

df 




