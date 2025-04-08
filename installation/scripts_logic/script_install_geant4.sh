#!/bin/bash
# Instala los requerimientos para Geant4 en Fedora
# Registro de paquetes fallidos y sugerencias
# Autores: A.Morales - N.Torres | Versión: 0.0.5 | Fecha: 07-04-2025

log_faltantes="paquetes_faltantes.log"
log_sugerencias="sugerencias_paquetes.log"
> "$log_faltantes"
> "$log_sugerencias"

check_and_install_package() {
    local pkg="$1"
    echo "🔍 Verificando: $pkg"
    if dnf list available "$pkg" &>/dev/null; then
        echo "✅ Instalando: $pkg"
        dnf install -y "$pkg"
    else
        echo "❌ No disponible: $pkg" | tee -a "$log_faltantes"
        echo "🔎 Sugerencias para $pkg:" | tee -a "$log_sugerencias"
        dnf list available | grep -i "${pkg}" | tee -a "$log_sugerencias"
        echo "--------------------------------------------------" >> "$log_sugerencias"
    fi
}

echo "⚠️ Este script debe ejecutarse como root"
echo "📦 Actualizando repositorios..."
dnf check-update
dnf install -y epel-release
dnf repolist

# Repositorio adicional
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
dnf install -y https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm

echo "📚 Requerimientos para Geant4 (manual 10.2, pág. 3)"
echo "🛠️ Instalando dependencias..."

paquetes=(
    cmake cmake-gui kernel-devel xerces-c-devel
    qt5-qtbase-devel motif-devel libX11-devel mesa-libGL-devel
    Coin3 freetype-devel
)

for pkg in "${paquetes[@]}"; do
    check_and_install_package "$pkg"
done

echo "📁 Preparando instalación"
read -p "📂 ¿Dónde desea instalar Geant4? " path_geant4
mkdir -p "$path_geant4"

read -p "📂 ¿Dónde desea trabajar temporalmente (descarga y build)? " path_temp
cd "$path_temp" || exit

read -p "🔗 Ingrese el link de descarga de Geant4: " geant_source
wget "$geant_source"
tar -xvf geant4*.tar.gz

read -p "📁 Nombre del directorio de build (ej: geant4-build): " dir_build
mkdir "$dir_build"
cd "$dir_build" || exit

read -p "📁 Ruta del código fuente extraído: " path_source

cmake -DCMAKE_INSTALL_PREFIX="$path_geant4" \
      -DGEANT4_INSTALL_DATA=ON \
      -DGEANT4_USE_OPENGL_X11=ON \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_STATIC_LIBS=ON \
      "$path_source"

number_proc=$(nproc)
echo "🧱 Compilando con $number_proc núcleos..."
make -j"$number_proc" VERBOSE=1

echo "✅ Proceso finalizado."

if [ -s "$log_faltantes" ]; then
    echo "⚠️ Algunos paquetes no se pudieron instalar. Revisa $log_faltantes"
    echo "💡 También puedes revisar $log_sugerencias para posibles alternativas."
fi
