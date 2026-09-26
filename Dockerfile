FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xrdp \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    firefox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash rdpuser && \
    echo 'rdpuser:RailwayRDP123!' | chpasswd && \
    adduser rdpuser sudo

RUN echo "startxfce4" > /home/rdpuser/.xsession && \
    chown rdpuser:rdpuser /home/rdpuser/.xsession

EXPOSE 3389

CMD service dbus start && \
    service xrdp start && \
    tail -f /var/log/xrdp.log
