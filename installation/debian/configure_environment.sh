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
ROOT_PREFIX="${ROOT_INSTALL_PREFIX:-${ROOT_PREFIX}}"
PROFILE_FILE="${PROFILE_FILE:-${ENVIRONMENT_FILE}}"

cat > "${PROFILE_FILE}" <<EOF
# Entorno generado por Geant4-Physics-Simulations.
if [ -f "${G4_PREFIX}/bin/geant4.sh" ]; then
    source "${G4_PREFIX}/bin/geant4.sh"
fi
if [ -f "${ROOT_PREFIX}/bin/thisroot.sh" ]; then
    source "${ROOT_PREFIX}/bin/thisroot.sh"
fi
EOF

chmod 0644 "${PROFILE_FILE}"
echo "Entorno configurado en ${PROFILE_FILE}. Abre una terminal nueva o ejecuta: source ${PROFILE_FILE}"
