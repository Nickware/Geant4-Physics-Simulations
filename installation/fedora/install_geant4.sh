#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Ejecuta este script con sudo o como root." >&2
    exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../config/versions.env
source "${SCRIPT_DIR}/../config/versions.env"

G4_PREFIX="${G4_PREFIX:-${GEANT4_PREFIX}}"
WORK_DIR="${WORK_DIR:-${INSTALL_WORK_DIR}}"
SOURCE_URL="${SOURCE_URL:-${GEANT4_SOURCE_URL}}"

read -rp "Ruta de instalación [${G4_PREFIX}]: " input_prefix
read -rp "Ruta de trabajo [${WORK_DIR}]: " input_work_dir
read -rp "URL del código fuente [${SOURCE_URL}]: " input_source_url
G4_PREFIX="${input_prefix:-${G4_PREFIX}}"
WORK_DIR="${input_work_dir:-${WORK_DIR}}"
SOURCE_URL="${input_source_url:-${SOURCE_URL}}"

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
