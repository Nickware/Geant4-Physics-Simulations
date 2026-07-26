# Instalación de ROOT con Python

## Distribuciones derivadas de Debian

Paso a paso detallado para instalar ROOT desde el código fuente, asegurando el soporte para Python. Este método da el mayor control sobre las dependencias.

------

## Instalación de ROOT con Soporte para Python (PyROOT)

El proceso de instalación se basa en **CMake** y sigue una metodología similar a la que se usa para Geant4.

### Paso 1: Requisitos Previos

Antes de compilar, asegurarse de que se tienen instaladas las dependencias de desarrollo, especialmente para Python.

1. **Instalar dependencias básicas:** Asegurarse de tener `git`, `g++` (o similar), `make`, y `cmake`.

2. **Instalar librerías de Python:** ROOT necesita los archivos de desarrollo de Python.

   - **En sistemas basados en Debian/Ubuntu (o Deepin):**

     Bash

     ```
     sudo apt update
     sudo apt install build-essential git libssl-dev libpcre2-dev \
                    libftgl-dev default-libmysqlclient-dev libcfitsio-dev \
                    libblas-dev liblapack-dev libfftw3-dev libxml2-dev \
                    python3-dev python3-pip
     ```

     El paquete crucial aquí es **`python3-dev`**.



### Paso 2: Descarga del Código Fuente



1. **Crea un directorio de trabajo** (ej. en la carpeta personal) y clonarlo desde el repositorio oficial de CERN.

   Bash

   ```
   mkdir root_install
   cd root_install
   # Clonar la versión estable más reciente (ej. v6-30-06)
   git clone --branch v6-30-06 --depth 1 https://github.com/root-project/root.git root_src
   ```



### Paso 3: Configuración con CMake (Activación de Python)



1. **Crear y entrar al directorio de compilación:**

   Bash

   ```
   mkdir build
   cd build
   ```

2. **Ejecutar CMake con \*flags\* de Python:** 

#### Plan A (en desarrollo)
Aquí es donde se le indica a ROOT qué sea el intérprete de Python para construir el soporte de `PyROOT`.

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

#### Plan B 

En caso de que la instrucción anterior no funcione correctamente, instalar cmake-gui y generar el cmake de instalación mediante esta via.

 Bash

   ```
   sudo apt install -y cmake-gui
   cmake-gui
   ```

### Paso 4: Compilación e Instalación

1. **Compilar ROOT:**

   Bash

   ```
   make -j$(nproc) # Usa todos los núcleos disponibles
   ```

2. **Instalar ROOT:**

   Bash

   ```
   sudo make install # Esto copiará los archivos a /opt/root
   ```



### Paso 5: Configuración del Entorno



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

## Distribuciones derivadas de Fedora

Para instalar ROOT en una distribución basada en **Fedora** (incluyendo AlmaLinux o Rocky), con soporte nativo para **Python**, sigue este procedimiento.

Como mencionamos anteriormente, **Octave y Scilab no son módulos nativos de ROOT** ni se integran directamente. La forma profesional de trabajar es realizar el análisis en ROOT/PyROOT y exportar los resultados a formato `.csv` o `.root` para procesarlos posteriormente en Octave o Scilab.

### 1. Habilitar el repositorio CRB

Ejecutar este comando:

```bash
sudo dnf install -y crb
sudo crb enable

```

#### 2. Actualizar el caché de DNF

Después de habilitar el repositorio, se debe refrescar la lista de paquetes para que el sistema reconozca los nuevos paquetes `-devel` que antes no encontraba:

```bash
sudo dnf clean all
sudo dnf makecache

```

---

## Paso 1: Instalación de Dependencias

Abrir terminal y ejecutar el siguiente comando para preparar el sistema:

```bash
sudo dnf install -y cmake gcc-c++ gcc binutils libX11-devel libXpm-devel \
                 libXft-devel libXext-devel python3-devel python3-numpy \
                 openssl-devel pcre-devel mesa-libGLU-devel glew-devel \
                 ftgl-devel fftw-devel cfitsio-devel graphviz-devel \
                 avahi-compat-libdnssd-devel libldap-devel \
                 graphviz-devel avahi-devel openldap-devel

```

## Paso 2: Descarga del Código Fuente

Crear una carpeta de trabajo, descargar la versión estable y prepárala:

```bash
mkdir ~/root_install && cd ~/root_install
# Clonar la versión más reciente (ej. v6-30-06)
git clone --branch v6-30-06 --depth 1 https://github.com/root-project/root.git root_src
mkdir build && cd build

```

## Paso 3: Configuración con CMake (Activación de Python)

Aquí se indica a ROOT que habilite `PyROOT` y detecte automáticamente la instalación de Python:

```bash
cmake -DCMAKE_INSTALL_PREFIX=/opt/root \
      -Dpyroot=ON \
      -DPython3_EXECUTABLE=$(which python3) \
      ../root_src

```

* **`-Dpyroot=ON`**: Activar el módulo para que se pueda importar ROOT en Python.
* **`-DCMAKE_INSTALL_PREFIX`**: Definir la ruta donde se instalará el software.

## Paso 4: Compilación e Instalación

Usar todos los núcleos de tu procesador para acelerar el proceso:

```bash
make -j$(nproc)
sudo make install

```

## Paso 5: Configuración del Entorno

Para que su sistema reconozca los comandos de ROOT y el módulo de Python, añadir esta línea al final del archivo `~/.bashrc`:

```bash
source /opt/root/bin/thisroot.sh

```

Luego, aplicar los cambios con: `source ~/.bashrc`.

---

## ¿Cómo trabajar con Octave o Scilab?

Como ROOT no tiene una librería de enlace directo (como un `import octave`), utilizar este flujo de trabajo científico:

1. **Análisis en ROOT:** Utiliza PyROOT para leer los datos de simulación y realizar el filtrado estadístico o ajustes (fits).
```python
import ROOT
# Cargar datos
f = ROOT.TFile("rdecay01.root")
tree = f.Get("ntuple")
# Exportar datos necesarios a CSV para Octave
with open("datos_analisis.csv", "w") as f_out:
    for entry in tree:
        f_out.write(f"{entry.energy}\n")

```


2. **Procesamiento en Octave/Scilab:**
Carga el archivo generado por ROOT para continuar el análisis numérico:
```octave
datos = load('datos_analisis.csv');
plot(datos);

```

Al usar este método, se puede aprovechar la potencia de **Geant4/ROOT** para la física de partículas y la especialización numérica de **Octave/Scilab** para el post-procesamiento.