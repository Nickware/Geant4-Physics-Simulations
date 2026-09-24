# Instalar Geant4 en Debian, Ubuntu o Deepin

Esta guía describe cómo preparar un entorno de desarrollo Geant4 en distribuciones basadas en Debian. El procedimiento puede realizarse manualmente o mediante los scripts de esta carpeta.

## Requisitos

- Debian, Ubuntu, Deepin o una distribución derivada.
- Conexión a Internet.
- Varios gigabytes libres para descargar y compilar Geant4.
- Un compilador C++, CMake, Git y permisos para instalar paquetes.
- Memoria suficiente para una compilación paralela; el instalador usa todos los núcleos disponibles.

Las versiones y rutas predeterminadas están en [`../config/versions.env`](../config/versions.env).

## Opción A: instalación automatizada

Desde la carpeta `installation/`:

```bash
sudo ./debian/install_dependencies.sh
sudo ./debian/install_geant4.sh
```

Para instalar también ROOT y PyROOT:

```bash
sudo ./debian/install_root.sh
sudo ./debian/configure_environment.sh
```

El instalador completo ejecuta todas las etapas anteriores:

```bash
sudo ./script_install_debian_users.sh
```

La configuración del entorno se escribe en `/etc/profile.d/geant4-root.sh`. No se modifica `.bashrc`.

## Opción C: instalar en un contenedor Distrobox

Distrobox permite mantener Geant4 y sus dependencias dentro de un contenedor Debian, sin mezclar paquetes con el sistema anfitrión. El proyecto y los archivos del usuario siguen siendo accesibles desde el contenedor.

### 1. Instalar Distrobox en el sistema anfitrión

En Debian o Ubuntu, instala Distrobox y Podman:

```bash
sudo apt update
sudo apt install -y distrobox podman
```

Comprueba la instalación:

```bash
distrobox --version
podman --version
```

### 2. Crear y entrar al contenedor

Usa una imagen versionada para que el entorno sea reproducible:

```bash
distrobox create --name geant4-debian --image debian:12
distrobox enter geant4-debian
```

Los siguientes comandos se ejecutan dentro del contenedor. El repositorio del proyecto estará disponible mediante los montajes de Distrobox.

### 3. Preparar el contenedor

Dentro del contenedor, instala Git y Sudo:

```bash
sudo apt update
sudo apt install -y git sudo
```

Si la imagen no ofrece `sudo` configurado para el usuario de Distrobox, abre una shell administrativa desde el anfitrión con `distrobox enter --root geant4-debian`, instala `sudo` y vuelve a entrar normalmente.

### 4. Ejecutar la instalación dentro del contenedor

Desde la carpeta `installation/` del repositorio, ejecuta los componentes Debian:

```bash
sudo ./debian/install_dependencies.sh
sudo ./debian/install_geant4.sh
sudo ./debian/install_root.sh
sudo ./debian/configure_environment.sh
source /etc/profile.d/geant4-root.sh
```

La instalación se realiza dentro del contenedor. Las rutas `/opt/geant4` y `/opt/root` pertenecen al contenedor, no al sistema anfitrión.

### 5. Verificar y salir

```bash
geant4-config --version
geant4-config --prefix
exit
```

Para volver a entrar más adelante:

```bash
distrobox enter geant4-debian
```

Para eliminar el entorno completo:

```bash
distrobox rm geant4-debian
```

## Opción B: instalación manual

### 1. Instalar dependencias

```bash
sudo apt update
sudo apt install -y \
  build-essential cmake git binutils \
  libx11-dev libxmu-dev libxpm-dev libxft-dev libxext-dev \
  libglu1-mesa-dev libglew-dev libftgl-dev libfftw3-dev \
  libcfitsio-dev libgraphviz-dev libavahi-compat-libdnssd-dev \
  libldap2-dev python3-dev python3-numpy libxml2-dev \
  libkrb5-dev libssl-dev libpcre3-dev libmotif-dev \
  libxerces-c-dev qtbase5-dev qtchooser qt5-qmake \
  qtbase5-dev-tools libgsl-dev
```

### 2. Descargar Geant4

Usa la versión definida en `../config/versions.env`. Por defecto, el repositorio está preparado para Geant4 `11.2.1`:

```bash
mkdir -p /var/tmp/geant4-physics-install
cd /var/tmp/geant4-physics-install
git clone --branch v11.2.1 --depth 1 \
  https://github.com/Geant4/geant4.git geant4-11.2.1-src
```

### 3. Configurar y compilar

```bash
cmake -S geant4-11.2.1-src -B geant4-11.2.1-build \
  -DCMAKE_INSTALL_PREFIX=/opt/geant4 \
  -DGEANT4_INSTALL_DATA=ON \
  -DGEANT4_USE_QT=ON \
  -DGEANT4_USE_OPENGL_X11=ON \
  -DGEANT4_USE_GDML=ON \
  -DGEANT4_BUILD_MULTITHREADED=ON

cmake --build geant4-11.2.1-build --parallel "$(nproc)"
sudo cmake --install geant4-11.2.1-build
```

### 4. Configurar el entorno

```bash
sudo ./debian/configure_environment.sh
source /etc/profile.d/geant4-root.sh
```

## Verificación

Comprueba que Geant4 está disponible:

```bash
geant4-config --version
geant4-config --prefix
```

El primer comando debe mostrar `11.2.1` y el segundo `/opt/geant4`, salvo que hayas cambiado `versions.env`.

Después, configura y compila un proyecto Geant4 que contenga `CMakeLists.txt` y código fuente:

```bash
cmake -S /ruta/al/proyecto -B /ruta/al/proyecto/build
cmake --build /ruta/al/proyecto/build --parallel "$(nproc)"
```

Los README de `modulo_1/Basic/B1` y `geant4-root` documentan ejemplos concretos del repositorio. El directorio de prácticas debe contener el código fuente del ejemplo; un README por sí solo no puede compilarse.

## Diagnóstico

- **`geant4-config: command not found`:** ejecuta `source /etc/profile.d/geant4-root.sh` y comprueba que `/opt/geant4/bin/geant4-config` exista.
- **CMake no encuentra Geant4:** indica el directorio de configuración con `-DGeant4_DIR=/opt/geant4/lib/Geant4-11.2.1` o localízalo con `find /opt/geant4 -name Geant4Config.cmake`.
- **Faltan Qt u OpenGL:** repite la instalación de dependencias y revisa que `GEANT4_USE_QT` y `GEANT4_USE_OPENGL_X11` sean compatibles con tu sistema.
- **La compilación consume demasiados recursos:** sustituye `--parallel "$(nproc)"` por un número menor, por ejemplo `--parallel 2`.
- **La descarga o compilación se interrumpe:** conserva el directorio de trabajo y vuelve a ejecutar CMake; no es necesario borrar todo el árbol de compilación.
- **El contenedor no inicia:** comprueba que Podman esté disponible y que el usuario tenga permisos para ejecutar contenedores rootless.
- **El proyecto no aparece dentro del contenedor:** entra desde la carpeta del repositorio o revisa los montajes mostrados por `distrobox list`.
