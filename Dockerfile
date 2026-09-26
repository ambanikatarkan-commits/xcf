FROM scottyhardy/docker-remote-desktop:latest

USER root

RUN apt-get update && \
    apt-get install -y wget ca-certificates && \
    wget -O /tmp/chrome.deb \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y /tmp/chrome.deb && \
    rm -f /tmp/chrome.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
