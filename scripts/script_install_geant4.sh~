#!/bin/bash
#Instala los requerimientos en el SO, 
#prepara el configurador para Geant4
#Construye los binarios de Geant4
#Probado en Scientific Linux 7.3
#Autores: A.Morales - N.Torres
#jntorresr@udistrital.edu.co
#Version: 0.0.3
#Fecha: 05-09-2017

############################################################################################################################################
echo "---------------------------Warning------------------------------------"
echo "Este script debe ser ejecutado como sudo o root"
echo "Actualizando los repositorios"
yum check-update
yum install epel-release
yum repolist
echo "importando clave pública" 
rpm -import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
echo "Descargando clave pública"
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
echo "Requerimientos necesarios para instalar Geant4" 
echo "Basado en el manual de instalación para construir binarios de Geant4"
echo "Véase manual versión 10.2 Pag 3"
echo "----------------Instalando requerimientos y dependencias---------------"
yum install cmake3 cmake3-gui
yum install kernel-devel
yum install xerces-c-devel
yum install qt5-qtbase-devel
yum install motif-devel 
yum install libX11-devel
yum install mesa-libGL-devel
yum install Coin3
yum install freetype-devel
echo "Preparando carpeta destino instalación"
echo "El manual recomienda /usr/local"
read -p "¿Donde desea ubicar los binarios de Geant4? " path_geant4
mkdir $path_geant4
read -p "¿Donde desea ubicarse temporalmente para descargar las fuentes y crear carpetas temporales? " path_temp
cd $path_temp
echo "Descargar versión actual de Geant4" 
echo "Copie el link asociado a la descarga de las fuentes que desea descargar desde la pagina oficial de Geant4" 
echo "Por ejemplo: http://cern.ch/geant4/support/source/geant4.10.03.p01.tar.gz"
read -p "Ingrese el link de descarga(Cópielo tal cual como dice en el ejemplo): " geant_source
wget $geant_source
echo "----------------------------Descomprimiendo----------------------------"
tar -xvf geant4.10.*
read -p "Indique el nombre de la carpeta de construcción(Por ejemplo, geant4.10.2-build): " dir_build
mkdir $dir_build
echo "Ingresando a la carpeta de construcción"
cd $dir_build
echo "Opciones para preparar la configuración de cmake"
echo "Para ver mas opciones véase el manual"
cmake -DCMAKE_INSTALL_PREFIX=/opt/geant4 -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_OPENGL_X11=ON -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON /opt/geant4.10.03.source/
echo "Obteniendo número de procesadores"
number_proc={nproc}
echo "-----------------Construyendo binarios------------------------------"
echo "Esta operación puede tomar un par de minutos, "
echo "dependiendo procesadores, numero de memoria y configuración definida."
make -j$number_proc VERBOSE=1
