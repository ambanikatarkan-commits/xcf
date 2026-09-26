FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Desktop + XRDP
RUN apt-get update && apt-get install -y \
    xrdp \
    xorgxrdp \
    xfce4 \
    xfce4-terminal \
    dbus-x11 \
    sudo \
    wget \
    curl \
    ca-certificates \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome
RUN wget -q -O /tmp/chrome.deb \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update \
    && apt-get install -y /tmp/chrome.deb \
    && rm -f /tmp/chrome.deb \
    && rm -rf /var/lib/apt/lists/*

# User RDP
RUN useradd -m -s /bin/bash rdpuser \
    && echo 'rdpuser:RailwayRDP123!' | chpasswd \
    && adduser rdpuser sudo

# XFCE session
RUN echo "startxfce4" > /home/rdpuser/.xsession \
    && chown rdpuser:rdpuser /home/rdpuser/.xsession

# Disable XFCE compositor supaya lebih ringan
RUN mkdir -p /home/rdpuser/.config/xfce4/xfconf/xfce-perchannel-xml \
    && printf '%s\n' \
    '<?xml version="1.0" encoding="UTF-8"?>' \
    '<channel name="xfwm4" version="1.0">' \
    '<property name="general" type="empty">' \
    '<property name="use_compositing" type="bool" value="false"/>' \
    '</property>' \
    '</channel>' \
    > /home/rdpuser/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml \
    && chown -R rdpuser:rdpuser /home/rdpuser/.config

EXPOSE 3389

CMD service dbus start && \
    service xrdp start && \
    tail -f /var/log/xrdp.log
