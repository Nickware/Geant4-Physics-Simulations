#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Ejecuta este script con sudo o como root." >&2
    exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../config/versions.env
source "${SCRIPT_DIR}/../config/versions.env"

G4_VERSION="${G4_VERSION:-${GEANT4_VERSION}}"
G4_PREFIX="${G4_PREFIX:-${GEANT4_PREFIX}}"
WORK_DIR="${WORK_DIR:-${INSTALL_WORK_DIR}}"
SOURCE_DIR="${WORK_DIR}/geant4-${G4_VERSION}-src"
BUILD_DIR="${WORK_DIR}/geant4-${G4_VERSION}-build"

mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
    git clone --branch "v${G4_VERSION}" --depth 1 \
    "${GEANT4_GIT_URL}" "${SOURCE_DIR}"
fi

cmake -S "${SOURCE_DIR}" -B "${BUILD_DIR}" \
    -DCMAKE_INSTALL_PREFIX="${G4_PREFIX}" \
    -DGEANT4_INSTALL_DATA=ON \
    -DGEANT4_USE_QT=ON \
    -DGEANT4_USE_OPENGL_X11=ON \
    -DGEANT4_USE_GDML=ON \
    -DGEANT4_BUILD_MULTITHREADED=ON

cmake --build "${BUILD_DIR}" --parallel "$(nproc)"
cmake --install "${BUILD_DIR}"

echo "Geant4 ${G4_VERSION} instalado en ${G4_PREFIX}."
