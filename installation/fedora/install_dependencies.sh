#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Ejecuta este script con sudo o como root." >&2
    exit 1
fi

PKG_MGR="$(command -v dnf || command -v yum || true)"
if [[ -z "${PKG_MGR}" ]]; then
    echo "No se encontró dnf ni yum." >&2
    exit 1
fi

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
fi

if [[ "${ID:-}" == "fedora" ]]; then
    FEDORA_VERSION="$(rpm -E %fedora)"
    "${PKG_MGR}" -y install epel-release || true
    "${PKG_MGR}" -y install \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm" || true
elif [[ "${ID:-}" =~ ^(rhel|centos|rocky|almalinux)$ ]] || [[ "${ID_LIKE:-}" == *rhel* ]]; then
    RHEL_VERSION="$(rpm -E %rhel)"
    "${PKG_MGR}" -y install epel-release || true
    "${PKG_MGR}" -y install \
        "https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-${RHEL_VERSION}.noarch.rpm" \
        "https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-${RHEL_VERSION}.noarch.rpm" || true
else
    echo "Distribución no reconocida: ${ID:-desconocida}" >&2
    exit 1
fi

"${PKG_MGR}" -y install \
    cmake cmake-gui kernel-devel xerces-c-devel expat-devel \
    qt5-qtbase-devel motif-devel libX11-devel mesa-libGL-devel \
    Coin3 freetype-devel unzip wget gsl-devel

echo "Dependencias Fedora/RHEL instaladas correctamente."
