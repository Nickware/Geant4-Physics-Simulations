#!/bin/bash
# =================================================================
# Script Universal de Instalación Geant4 (Familia RHEL)
# Autores: A.Morales - N.Torres | Adaptación: Asistente IA
# =================================================================

set -euo pipefail

LOG_SUCCESS="paquetes_instalados.log"
LOG_FAIL="paquetes_fallidos.log"
> "${LOG_SUCCESS}"
> "${LOG_FAIL}"

if [ "${EUID}" -ne 0 ]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

PKG_MGR="$(command -v dnf || command -v yum || true)"
if [ -z "${PKG_MGR}" ]; then
    echo "No se encontró 'dnf' ni 'yum'. Instale un gestor de paquetes compatible." | tee -a "${LOG_FAIL}"
    exit 1
fi

RHEL_VERSION="$(rpm -E %rhel)"
echo "Detectada arquitectura RHEL ${RHEL_VERSION}"

echo "Preparando repositorios..."
${PKG_MGR} -y install epel-release || true
${PKG_MGR} -y install "https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-${RHEL_VERSION}.noarch.rpm" || true
${PKG_MGR} -y install "https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-${RHEL_VERSION}.noarch.rpm" || true

install_pkg() {
    local pkg="$1"
    echo "Verificando/Instalando: ${pkg}..."
    if ${PKG_MGR} -y install "${pkg}" &>> "${LOG_SUCCESS}"; then
        echo "${pkg} INSTALADO correctamente." >> "${LOG_SUCCESS}"
    else
        echo "Advertencia: No se pudo instalar '${pkg}'." | tee -a "${LOG_FAIL}"
        echo "Buscando nombres similares para '${pkg}'..." >> "${LOG_FAIL}"
        ${PKG_MGR} search "${pkg}" | head -n 20 >> "${LOG_FAIL}" || true
        echo "--------------------------------------------------" >> "${LOG_FAIL}"
    fi
}

paquetes=(
    cmake cmake-gui kernel-devel xerces-c-devel expat-devel
    qt5-qtbase-devel motif-devel libX11-devel mesa-libGL-devel
    Coin3 freetype-devel unzip wget
)

echo "Instalando paquetes normalizados para Geant4..."
for pkg in "${paquetes[@]}"; do
    install_pkg "${pkg}"
done

read -rp "Ruta de instalación (ej: /opt/geant4): " path_geant4
read -rp "Ruta de trabajo temporal (ej: /tmp/geant4_build): " path_temp
mkdir -p "${path_geant4}" "${path_temp}"
cd "${path_temp}" || exit 1

read -rp "Link de descarga (zip o tar.gz): " geant_source
wget -q "${geant_source}"
archivo_descargado="$(basename "${geant_source}")"

echo "Extrayendo archivos..."
mkdir -p source_dir
if [[ "${archivo_descargado}" == *.zip ]]; then
    unzip -q "${archivo_descargado}" -d source_dir
elif [[ "${archivo_descargado}" == *.tar.gz ]] || [[ "${archivo_descargado}" == *.tgz ]]; then
    tar -xzf "${archivo_descargado}" -C source_dir
else
    echo "Formato no reconocido: ${archivo_descargado}. Saliendo."
    exit 1
fi

path_source="${path_temp}/source_dir/$(find source_dir -mindepth 1 -maxdepth 1 | head -n 1 | xargs basename)"
if [ ! -d "${path_source}" ]; then
    echo "No se pudo determinar el directorio fuente en source_dir." >&2
    exit 1
fi

mkdir -p build_dir
cd build_dir || exit 1

cmake -DCMAKE_INSTALL_PREFIX="${path_geant4}" \
      -DGEANT4_INSTALL_DATA=ON \
      -DGEANT4_USE_OPENGL_X11=ON \
      -DBUILD_SHARED_LIBS=ON \
      "${path_source}"

number_proc="$(nproc)"
echo "Compilando con ${number_proc} núcleos..."
make -j"${number_proc}"
make install

echo "Proceso finalizado. Geant4 instalado en ${path_geant4}."
echo "Logs de instalación disponibles en ${LOG_SUCCESS} y ${LOG_FAIL}."
