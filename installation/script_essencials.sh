#!/bin/bash

# =================================================================
# Script Universal para Familia RHEL (CentOS, Alma, Rocky, RHEL) y Fedora
# =================================================================

# === CONFIGURACIÓN ===
LOG_SUCCESS="paquetes_instalados.log"
LOG_FAIL="paquetes_fallidos.log"

# Limpiar logs anteriores
> "${LOG_SUCCESS}"
> "${LOG_FAIL}"

# Verifica permisos de root
if [ "${EUID}" -ne 0 ]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

echo "--- Iniciando configuración ---"

# Detectar gestor de paquetes disponible
PKG_MGR="$(command -v dnf || command -v yum || true)"
if [ -z "${PKG_MGR}" ]; then
    echo "No se encontró 'dnf' ni 'yum'. Instale un gestor de paquetes compatible." | tee -a "${LOG_FAIL}"
    exit 1
fi

# Cargar /etc/os-release si existe
if [ -f /etc/os-release ]; then
    . /etc/os-release
fi

is_fedora=false
is_rhel_family=false
if [ "${ID}" = "fedora" ] || [[ "${ID_LIKE}" == *fedora* ]]; then
    is_fedora=true
fi
if [[ "${ID}" =~ (rhel|centos|rocky|almalinux) ]] || [[ "${ID_LIKE}" == *rhel* ]]; then
    is_rhel_family=true
fi

# Función de instalación inteligente y logging
install_pkg() {
    local pkg="$1"
    echo "Instalando: ${pkg}..."
    if ${PKG_MGR} -y install "${pkg}" &>> "${LOG_SUCCESS}"; then
        echo "${pkg} INSTALADO correctamente." >> "${LOG_SUCCESS}"
        return 0
    else
        echo "No se pudo instalar '${pkg}' con ${PKG_MGR}." | tee -a "${LOG_FAIL}"
        echo "Buscando nombres similares para '${pkg}'..." >> "${LOG_FAIL}"
        ${PKG_MGR} search "${pkg}" | head -n 20 >> "${LOG_FAIL}" || true
        echo "" >> "${LOG_FAIL}"
        return 1
    fi
}

if [ "${is_fedora}" = true ]; then
    FEDORA_VERSION=$(rpm -E %fedora)
    echo "Versión de Fedora: ${FEDORA_VERSION}"
    echo "Agregando repositorios para Fedora..."
    ${PKG_MGR} -y install epel-release || true
    RPMFUSION_FREE="https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm"
    RPMFUSION_NONFREE="https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"
    ${PKG_MGR} -y install "${RPMFUSION_FREE}" "${RPMFUSION_NONFREE}" || true
    echo "Actualizando sistema..."
    ${PKG_MGR} -y upgrade || true

    packages=(
        gstreamer1-plugins-good-extras
        gstreamer1-plugins-ugly
        gstreamer-ffmpeg
        xine-lib-extras
        xine-lib-extras-freeworld
        gstreamer-plugins-bad
        gstreamer-plugins-bad-free-extras
        gstreamer-plugins-bad-nonfree
        gstreamer1-plugins-bad
        gstreamer1-plugins-base-tools
        smplayer
        mplayer
        ffmpeg
        unzip
        unrar-free
        p7zip
        kernel-headers
        kernel-devel
        dkms
        libreoffice-langpack-es
        cheese
        hunspell
        hunspell-es
        wget
        curl
        nano
        java-21-openjdk
        java-21-openjdk-devel
    )

    echo "Comenzando la instalación de paquetes en Fedora..."
    for pkg in "${packages[@]}"; do
        install_pkg "${pkg}"
    done

elif [ "${is_rhel_family}" = true ]; then
    RHEL_VERSION=$(rpm -E %rhel)
    echo "Versión RHEL detectada: ${RHEL_VERSION}"
    echo "Configurando repositorios para RHEL..."
    ${PKG_MGR} -y install epel-release || true
    ${PKG_MGR} -y install "https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-${RHEL_VERSION}.noarch.rpm" || true
    ${PKG_MGR} -y install "https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-${RHEL_VERSION}.noarch.rpm" || true

    echo "Actualizando sistema..."
    ${PKG_MGR} -y upgrade || true

    packages=(
        ffmpeg
        gstreamer1-plugins-ugly
        gstreamer1-plugins-bad-free
        smplayer
        unzip
        unrar
        p7zip
        kernel-headers
        kernel-devel
        dkms
        hunspell
        hunspell-es
        wget
        curl
        nano
        java-21-openjdk-devel
    )

    echo "Comenzando la instalación de paquetes en RHEL family..."
    for pkg in "${packages[@]}"; do
        install_pkg "${pkg}"
    done

else
    echo "Distribución no reconocida. Intentando instalar paquetes de forma genérica..."
    packages=(
        ffmpeg
        wget
        curl
        nano
    )
    for pkg in "${packages[@]}"; do
        install_pkg "${pkg}"
    done
fi

echo "" 
echo "--- ¡Configuración finalizada! ---"
echo "Logs: ${LOG_SUCCESS} (éxitos), ${LOG_FAIL} (fallos/sugerencias)"
echo "El sistema está listo para compilar Geant4/ROOT si las dependencias se instalaron correctamente."
