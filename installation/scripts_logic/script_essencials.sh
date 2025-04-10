#!/bin/bash

# === CONFIGURACIÓN ===

LOG_SUCCESS="paquetes_instalados.log"
LOG_FAIL="paquetes_fallidos.log"
FEDORA_VERSION=$(rpm -E %fedora)

# Limpiar logs anteriores
> "$LOG_SUCCESS"
> "$LOG_FAIL"

# Función para verificar, instalar y loguear paquetes
check_and_install() {
    local package=$1
    echo " Verificando: $package"

    if dnf list "$package" &>/dev/null; then
        echo " Instalando: $package"
        if dnf -y install "$package" &>> "$LOG_SUCCESS"; then
            echo "$package INSTALADO correctamente." >> "$LOG_SUCCESS"
        else
            echo " Error al instalar $package" | tee -a "$LOG_FAIL"
        fi
    else
        echo "  El paquete '$package' no se encontró." | tee -a "$LOG_FAIL"
        echo " Buscando paquetes similares a '$package':" >> "$LOG_FAIL"
        dnf search "$package" | tee -a "$LOG_FAIL"
        echo "" >> "$LOG_FAIL"
    fi
}

# === INICIO DEL SCRIPT ===

# Verifica permisos de root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

echo " Versión de Fedora:"
cat /etc/fedora-release
echo ""

echo " Agregando repositorios..."
dnf -y install epel-release

RPMFUSION_FREE="https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm"
RPMFUSION_NONFREE="https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"
dnf -y install "$RPMFUSION_FREE" "$RPMFUSION_NONFREE"

# ElRepo es opcional, puede fallar sin afectar el flujo
dnf -y install https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm || \
    echo " ElRepo no es compatible con esta versión de Fedora."

echo " Actualizando sistema..."
dnf -y upgrade

# === LISTA DE PAQUETES ===

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

echo " Comenzando la instalación de paquetes..."
for pkg in "${packages[@]}"; do
    check_and_install "$pkg"
done

# === RESUMEN FINAL ===
echo ""
echo " Instalación completada. Consulta los siguientes archivos de log:"
echo "  $LOG_SUCCESS : Paquetes instalados con éxito."
echo "  $LOG_FAIL    : Paquetes no encontrados o con errores, junto con sugerencias."
