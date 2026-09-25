#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Ejecuta este script con sudo o como root." >&2
    exit 1
fi

read -rp "Ruta de instalación (ej: /opt/geant4): " G4_PREFIX
read -rp "Ruta de trabajo temporal (ej: /tmp/geant4_build): " WORK_DIR
read -rp "URL del código fuente (.zip, .tar.gz o .tgz): " SOURCE_URL

mkdir -p "${G4_PREFIX}" "${WORK_DIR}"
cd "${WORK_DIR}"

ARCHIVE="$(basename "${SOURCE_URL}")"
curl --fail --location --remote-name "${SOURCE_URL}"
mkdir -p source_dir

case "${ARCHIVE}" in
    *.zip) unzip -q "${ARCHIVE}" -d source_dir ;;
    *.tar.gz|*.tgz) tar -xzf "${ARCHIVE}" -C source_dir ;;
    *) echo "Formato no reconocido: ${ARCHIVE}" >&2; exit 1 ;;
esac

SOURCE_DIR="$(find source_dir -mindepth 1 -maxdepth 1 -type d -print -quit)"
if [[ -z "${SOURCE_DIR}" ]]; then
    echo "No se pudo determinar el directorio fuente." >&2
    exit 1
fi

BUILD_DIR="${WORK_DIR}/build_dir"
cmake -S "${SOURCE_DIR}" -B "${BUILD_DIR}" \
    -DCMAKE_INSTALL_PREFIX="${G4_PREFIX}" \
    -DGEANT4_INSTALL_DATA=ON \
    -DGEANT4_USE_OPENGL_X11=ON \
    -DBUILD_SHARED_LIBS=ON

cmake --build "${BUILD_DIR}" --parallel "$(nproc)"
cmake --install "${BUILD_DIR}"

echo "Geant4 instalado en ${G4_PREFIX}."
