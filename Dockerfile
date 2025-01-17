FROM kalilinux/kali-rolling:latest

LABEL website="https://github.com/iphoneintosh/kali-docker"
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."

# Install kali packages
ARG KALI_METAPACKAGE=core
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install kali-linux-${KALI_METAPACKAGE} --fix-missing
RUN apt-get clean

# Install kali desktop
ARG KALI_DESKTOP=xfce
RUN apt-get -y install kali-desktop-${KALI_DESKTOP}
RUN apt-get -y install tightvncserver dbus dbus-x11 novnc net-tools
ENV USER root

# Create Kali User
RUN useradd -rm -d /home/kali -s /bin/bash -g root -G sudo,audio,video -u 1001 kali -p "$(openssl passwd -1 kali)"

#VNC env variables
ENV VNCEXPOSE 0
ENV VNCPORT 5900
ENV VNCPWD changeme
ENV VNCDISPLAY 1920x1080
ENV VNCDEPTH 16

ENV NOVNCPORT 8080

# Install custom packages
# TODO: You can add your own packages here
RUN apt-get -y install xrdp xorg xorgxrdp nano firefox-esr

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]