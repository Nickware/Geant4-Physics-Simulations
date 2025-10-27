## Instalación de ROOT con Soporte para Python (PyROOT) (En desarrollo)

El proceso de instalación se basa en **CMake** y sigue una metodología similar a la que ya usaste para Geant4.

### Fase 1: Requisitos Previos

Antes de compilar, se debe asegurar de que se tengan instaladas las dependencias de desarrollo, especialmente para Python.

1. **Instalar dependencias básicas:** Asegurarse de tener `git`, `g++` (o similar), `make` y `cmake`.

2.  **Instalar librerías de Python:** ROOT necesita los archivos de desarrollo de Python.

      * **En sistemas basados en Debian/Ubuntu (o Deepin):**
        ```bash
        sudo apt update
        sudo apt install build-essential git libssl-dev libpcre3-dev \
                       libftgl-dev libmysqlclient-dev libcfitsio-dev \
                       libblas-dev liblapack-dev libfftw3-dev libxml2-dev \
                       python3-dev python3-pip
        ```
        El paquete crucial aquí es **`python3-dev`**.

### Fase 2: Descarga del Código Fuente

1.  **Crea un directorio de trabajo** (ej. en su carpeta personal) y clónar desde el repositorio oficial de CERN.
    ```bash
    mkdir root_install
    cd root_install
    # Clonar la versión estable más reciente (ej. v6-30-06)
    git clone --branch v6-30-06 --depth 1 https://github.com/root-project/root.git root_src
    ```

### Fase 3: Configuración con CMake (Activación de Python)

1.  **Crea y entra al directorio de compilación:**

    ```bash
    mkdir build
    cd build
    ```

2.  **Ejecutar CMake con *flags* de Python:** Aquí es donde se le dice a ROOT qué intérprete de Python debe usar para construir el soporte de `PyROOT`.

    ```bash
    cmake -DCMAKE_INSTALL_PREFIX=/opt/root \
          -DPYTHON_EXECUTABLE=$(which python3) \
          -DPYTHON_INCLUDE_DIR=$(python3 -c "from sysconfig import get_paths; print(get_paths()['include'])") \
          -DPYTHON_LIBRARY=$(python3 -c "import sysconfig as s; print(s.get_config_var('LIBDIR') + '/' + s.get_config_var('LDLIBRARY'))") \
          ../root_src
    ```

      * **`-DCMAKE_INSTALL_PREFIX`**: Define la ubicación final de la instalación (ej. `/opt/root`).
      * **`-DPYTHON_EXECUTABLE`**: Indica la ruta al binario de Python (obtenida con `$(which python3)`).
      * **`-DPYTHON_INCLUDE_DIR` y `-DPYTHON_LIBRARY`**: Aseguran que se usen las cabeceras y librerías de desarrollo de tu Python instalado.

### Fase 4: Compilación e Instalación

1.  **Compila ROOT:**
    ```bash
    make -j$(nproc) # Usa todos los núcleos disponibles
    ```
2.  **Instala ROOT:**
    ```bash
    sudo make install # Esto copiará los archivos a /opt/root
    ```

### Fase 5: Configuración del Entorno

Para que el sistema operativo sepa dónde encontrar los archivos y comandos de ROOT, se deben configurar las variables de entorno.

1.  **Ejecuta el *script* de configuración:**

    ```bash
    source /opt/root/bin/thisroot.sh
    ```

2.  **Verificación de Python:** Abrir un intérprete de Python y verificar que se puede importar la librería.

    ```bash
    python3
    >>> import ROOT
    >>> print(ROOT.gROOT.GetVersion())
    ```

    Si no hay errores, ¡PyROOT está instalado correctamente!

