# Instalar Geant4 en Fedora y sistemas RHEL

Esta guía describe cómo preparar un entorno de desarrollo Geant4 en Fedora, RHEL, Rocky Linux, AlmaLinux y CentOS compatibles. El procedimiento puede realizarse mediante los scripts separados de esta carpeta.

## Requisitos

- Fedora o una distribución compatible de la familia RHEL.
- `dnf` o `yum` disponible.
- Conexión a Internet.
- Varios gigabytes libres para descargar y compilar Geant4.
- Permisos administrativos para instalar paquetes y escribir en la ruta de instalación.

Las versiones y rutas predeterminadas están en [`../config/versions.env`](../config/versions.env). El instalador Fedora usa por defecto la versión y la URL de Geant4 definidas allí.

## Instalación automatizada

Desde la carpeta `installation/`, instala primero las dependencias:

```bash
sudo ./fedora/install_dependencies.sh
```

Después instala Geant4:

```bash
sudo ./fedora/install_geant4.sh
```

El script muestra valores predeterminados para la ruta de instalación, el directorio de trabajo y la URL. Pulsa Enter para conservarlos. También se puede ejecutar el wrapper compatible:

```bash
sudo ./script_install_fedora_users.sh
```

Este flujo instala Geant4, pero no instala ROOT ni configura automáticamente el entorno del usuario.

## Instalación manual

### 1. Instalar dependencias

El script de dependencias configura los repositorios necesarios y utiliza `dnf` o `yum` según el sistema:

```bash
sudo ./fedora/install_dependencies.sh
```

Las dependencias principales incluyen CMake, Qt, X11, Motif, OpenGL, GDML, herramientas de extracción y GSL.

### 2. Descargar Geant4

Usa la versión y URL de `../config/versions.env`. Para el valor predeterminado actual:

```bash
mkdir -p /var/tmp/geant4-physics-install
cd /var/tmp/geant4-physics-install
curl --fail --location --remote-name \
  https://github.com/Geant4/geant4/releases/download/v11.2.1/geant4-v11.2.1.tar.gz
mkdir -p source_dir
tar -xzf geant4-v11.2.1.tar.gz -C source_dir
```

### 3. Configurar y compilar

```bash
cmake -S source_dir/geant4-v11.2.1 -B build_dir \
  -DCMAKE_INSTALL_PREFIX=/opt/geant4 \
  -DGEANT4_INSTALL_DATA=ON \
  -DGEANT4_USE_OPENGL_X11=ON \
  -DBUILD_SHARED_LIBS=ON

cmake --build build_dir --parallel "$(nproc)"
sudo cmake --install build_dir
```

### 4. Cargar el entorno

El instalador Fedora no crea un archivo global de entorno. Después de instalar Geant4, puedes cargar el script generado por la instalación:

```bash
source /opt/geant4/bin/geant4.sh
```

Para dejar esta configuración disponible para todos los usuarios, crea un archivo administrado por el sistema:

```bash
sudo tee /etc/profile.d/geant4.sh >/dev/null <<'EOF'
if [ -f /opt/geant4/bin/geant4.sh ]; then
    source /opt/geant4/bin/geant4.sh
fi
EOF
sudo chmod 0644 /etc/profile.d/geant4.sh
```

## Verificación

```bash
geant4-config --version
geant4-config --prefix
```

El resultado predeterminado debe ser Geant4 `11.2.1` y `/opt/geant4`.

Para verificar una aplicación, usa un proyecto que contenga `CMakeLists.txt` y código fuente:

```bash
cmake -S /ruta/al/proyecto -B /ruta/al/proyecto/build
cmake --build /ruta/al/proyecto/build --parallel "$(nproc)"
```

Los README de `modulo_1/Basic/B1` y `geant4-root` documentan ejemplos concretos. Un archivo README sin el código fuente del ejemplo no puede compilarse por sí solo.

## Diagnóstico

- **`dnf` o `yum` no encuentra un paquete:** revisa la distribución, sus repositorios habilitados y el archivo de logs generado por los scripts.
- **`geant4-config: command not found`:** ejecuta `source /opt/geant4/bin/geant4.sh` y comprueba que `/opt/geant4/bin/geant4-config` exista.
- **CMake no encuentra Geant4:** usa `-DGeant4_DIR=/opt/geant4/lib/Geant4-11.2.1` o localiza `Geant4Config.cmake` con `find /opt/geant4 -name Geant4Config.cmake`.
- **Qt u OpenGL no están disponibles:** vuelve a ejecutar `sudo ./fedora/install_dependencies.sh` y revisa la salida de CMake.
- **La compilación consume demasiados recursos:** reduce el paralelismo, por ejemplo `cmake --build build_dir --parallel 2`.
- **La descarga falla:** comprueba la URL de `versions.env`, la conexión y el espacio disponible antes de repetirla.
