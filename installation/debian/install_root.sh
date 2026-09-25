#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Ejecuta este script con sudo o como root." >&2
    exit 1
fi

ROOT_BRANCH="${ROOT_BRANCH:-v6-30-06}"
ROOT_PREFIX="${ROOT_PREFIX:-/opt/root}"
WORK_DIR="${WORK_DIR:-${HOME}/physics_software}"
SOURCE_DIR="${WORK_DIR}/root-src"
BUILD_DIR="${WORK_DIR}/root-build"

mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
    git clone --branch "${ROOT_BRANCH}" --depth 1 \
        https://github.com/root-project/root.git "${SOURCE_DIR}"
fi

cmake -S "${SOURCE_DIR}" -B "${BUILD_DIR}" \
    -DCMAKE_INSTALL_PREFIX="${ROOT_PREFIX}" \
    -Dpyroot=ON \
    -Dgnuinstall=OFF

cmake --build "${BUILD_DIR}" --parallel "$(nproc)"
cmake --install "${BUILD_DIR}"

echo "ROOT ${ROOT_BRANCH} instalado en ${ROOT_PREFIX}."
