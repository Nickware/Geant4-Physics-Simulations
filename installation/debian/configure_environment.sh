#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Ejecuta este script con sudo o como root." >&2
    exit 1
fi

G4_PREFIX="${G4_PREFIX:-/opt/geant4}"
ROOT_PREFIX="${ROOT_PREFIX:-/opt/root}"
PROFILE_FILE="/etc/profile.d/geant4-root.sh"

cat > "${PROFILE_FILE}" <<EOF
# Entorno generado por Geant4-Physics-Simulations.
if [[ -f "${G4_PREFIX}/bin/geant4.sh" ]]; then
    source "${G4_PREFIX}/bin/geant4.sh"
fi
if [[ -f "${ROOT_PREFIX}/bin/thisroot.sh" ]]; then
    source "${ROOT_PREFIX}/bin/thisroot.sh"
fi
EOF

chmod 0644 "${PROFILE_FILE}"
echo "Entorno configurado en ${PROFILE_FILE}. Abre una terminal nueva o ejecuta: source ${PROFILE_FILE}"
