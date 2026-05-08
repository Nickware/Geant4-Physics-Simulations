#!/bin/bash

# =================================================================
# Script de instalación de Geant4 y ROOT para Debian/Deepin
# =================================================================

# Salir si ocurre un error
set -e

echo "--- Iniciando actualización de sistema e instalación de dependencias ---"
apt update
apt install -y build-essential cmake git binutils libx11-dev libxmu-dev \
libxpm-dev libxft-dev libxext-dev libcanvas-pw-perl libglu1-mesa-dev \
libglew-dev libftgl-dev libfftw3-dev libcfitsio-dev libgraphviz-dev \
libavahi-compat-libdnssd-dev libldap2-dev python3-dev python3-numpy \
libxml2-dev libkrb5-dev libssl-dev libpcre3-dev libmotif-dev \
libxerces-c-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools

# Directorio base para la compilación
BASE_DIR="$HOME/physics_software"
mkdir -p $BASE_DIR
cd $BASE_DIR

# =================================================================
# INSTALACIÓN DE GEANT4
# =================================================================
echo "--- Descargando y compilando Geant4 ---"
G4_VERSION="11.2.1"
G4_DIR="/opt/geant4"

git clone --branch v$G4_VERSION https://github.com/Geant4/geant4.git g4_src
mkdir -p g4_build
cd g4_build

cmake -DCMAKE_INSTALL_PREFIX=$G4_DIR \
      -DGEANT4_INSTALL_DATA=ON \
      -DGEANT4_USE_QT=ON \
      -DGEANT4_USE_OPENGL_X11=ON \
      -DGEANT4_USE_GDML=ON \
      -DGEANT4_BUILD_MULTITHREADED=ON \
      ../g4_src

make -j$(nproc)
make install
cd ..

# =================================================================
# INSTALACIÓN DE ROOT
# =================================================================
echo "--- Descargando y compilando ROOT ---"
ROOT_DIR="/opt/root"

git clone --branch latest-stable --depth 1 https://github.com/root-project/root.git root_src
mkdir -p root_build
cd root_build

cmake -DCMAKE_INSTALL_PREFIX=$ROOT_DIR \
      -Dpyroot=ON \
      -Dgnuinstall=OFF \
      ../root_src

make -j$(nproc)
make install

# =================================================================
# CONFIGURACIÓN DE VARIABLES DE ENTORNO
# =================================================================
echo "--- Configurando variables de entorno en .bashrc ---"

# Evitar duplicados si se corre el script dos veces
sed -i '/geant4.sh/d' ~/.bashrc
sed -i '/thisroot.sh/d' ~/.bashrc

echo "source $G4_DIR/bin/geant4.sh" >> ~/.bashrc
echo "source $ROOT_DIR/bin/thisroot.sh" >> ~/.bashrc

echo "--- ¡INSTALACIÓN COMPLETADA! ---"
echo "Reiniciar terminal o ejecutar: source ~/.bashrc"
