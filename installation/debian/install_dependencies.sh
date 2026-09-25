#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Ejecuta este script con sudo o como root." >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y \
    build-essential cmake git binutils \
    libx11-dev libxmu-dev libxpm-dev libxft-dev libxext-dev \
    libglu1-mesa-dev libglew-dev libftgl-dev libfftw3-dev \
    libcfitsio-dev libgraphviz-dev libavahi-compat-libdnssd-dev \
    libldap2-dev python3-dev python3-numpy libxml2-dev \
    libkrb5-dev libssl-dev libpcre3-dev libmotif-dev \
    libxerces-c-dev qtbase5-dev qtchooser qt5-qmake \
    qtbase5-dev-tools libgsl-dev

echo "Dependencias Debian instaladas correctamente."
