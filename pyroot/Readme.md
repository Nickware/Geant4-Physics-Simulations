



# Instalación de ROOT con soporte para Python

Paso a paso detallado para instalar ROOT desde el código fuente, asegurando el soporte para Python. Este método te da el mayor control sobre las dependencias.

------

## Instalación de ROOT con Soporte para Python (PyROOT)

El proceso de instalación se basa en **CMake** y sigue una metodología similar a la que se usas para Geant4.

### Fase 1: Requisitos Previos

Antes de compilar, asegurarse que se tiene instaladas las dependencias de desarrollo, especialmente para Python.

1. **Instalar dependencias básicas:** Asegurarse de tener `git`, `g++` (o similar), `make`, y `cmake`.

2. **Instalar librerías de Python:** ROOT necesita los archivos de desarrollo de Python.

   - **En sistemas basados en Debian/Ubuntu (o Deepin):**

     Bash

     ```
     sudo apt update
     sudo apt install build-essential git libssl-dev libpcre3-dev \
                    libftgl-dev libmysqlclient-dev libcfitsio-dev \
                    libblas-dev liblapack-dev libfftw3-dev libxml2-dev \
                    python3-dev python3-pip
     ```

     El paquete crucial aquí es **`python3-dev`**.



### Fase 2: Descarga del Código Fuente



1. **Crea un directorio de trabajo** (ej. en la carpeta personal) y clonarlo desde el repositorio oficial de CERN.

   Bash

   ```
   mkdir root_install
   cd root_install
   # Clonar la versión estable más reciente (ej. v6-30-06)
   git clone --branch v6-30-06 --depth 1 https://github.com/root-project/root.git root_src
   ```



### Fase 3: Configuración con CMake (Activación de Python)



1. **Crear y entrar al directorio de compilación:**

   Bash

   ```
   mkdir build
   cd build
   ```

2. **Ejecutar CMake con \*flags\* de Python:** Aquí es donde se le indica a ROOT qué sea el intérprete de Python para construir el soporte de `PyROOT`.

   Bash

   ```
   cmake -DCMAKE_INSTALL_PREFIX=/opt/root \
         -DPYTHON_EXECUTABLE=$(which python3) \
         -DPYTHON_INCLUDE_DIR=$(python3 -c "from sysconfig import get_paths; print(get_paths()['include'])") \
         -DPYTHON_LIBRARY=$(python3 -c "import sysconfig as s; print(s.get_config_var('LIBDIR') + '/' + s.get_config_var('LDLIBRARY'))") \
         ../root_src
   ```

   - **`-DCMAKE_INSTALL_PREFIX`**: Definir la ubicación final de la instalación (ej. `/opt/root`).
   - **`-DPYTHON_EXECUTABLE`**: Indicar la ruta al binario de Python (obtenida con `$(which python3)`).
   - **`-DPYTHON_INCLUDE_DIR` y `-DPYTHON_LIBRARY`**: Asegurarse que se usen las cabeceras y librerías de desarrollo de Python instalado.



### Fase 4: Compilación e Instalación



1. **Compila ROOT:**

   Bash

   ```
   make -j$(nproc) # Usa todos los núcleos disponibles
   ```

2. **Instala ROOT:**

   Bash

   ```
   sudo make install # Esto copiará los archivos a /opt/root
   ```



### Fase 5: Configuración del Entorno



Para que el sistema operativo sepa dónde encontrar los archivos y comandos de ROOT, se debe configurar las variables de entorno.

1. **Ejecuta el \*script\* de configuración:**

   Bash

   ```
   source /opt/root/bin/thisroot.sh
   ```

2. **Verificación de Python:** Abrir un intérprete de Python y verificar que puede importar la librería.

   Bash

   ```
   python3
   >>> import ROOT
   >>> print(ROOT.gROOT.GetVersion())
   ```

   Si no hay errores, ¡PyROOT está instalado correctamente!
