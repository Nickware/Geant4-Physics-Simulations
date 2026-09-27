#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

"${SCRIPT_DIR}/debian/install_dependencies.sh"
"${SCRIPT_DIR}/debian/install_geant4.sh"
"${SCRIPT_DIR}/debian/install_root.sh"
"${SCRIPT_DIR}/debian/configure_environment.sh"

echo "Geant4 y ROOT fueron instalados. Revisa la configuración del entorno antes de usarlos."
