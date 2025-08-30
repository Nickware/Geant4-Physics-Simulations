# Ejercicio Práctico: Ejecutando el ejemplo Básico B1 de Geant4

Este ejercicio guiará a través de la compilación y ejecución del **ejemplo básico B1 de Geant4**, una simulación simple del paso de una partícula a través de un detector.

El objetivo es familiarizarse con el proceso de trabajo con proyectos de Geant4 basados en **CMake**, incluyendo la gestión de dependencias comunes que a menudo causan errores en la configuración inicial.

-----

### Requisitos Previos

Antes de comenzar, asegúrarse de tener instalados los siguientes programas en el sistema:

  * **Geant4**: La versión 10.6.p03 o superior.
  * **CMake**: Versión 3.10 o superior.
  * **Un compilador de C++**: Por ejemplo, `g++`.
  * **Dependencias de desarrollo**: Las siguientes librerías son esenciales y suelen ser la causa de los errores más comunes:
      * **Xerces-C++**: Necesario para el soporte de GDML.
      * **Qt 4/5/6**: Para la visualización gráfica.
      * **Motif y X11**: Para el *driver* de visualización OpenGL en sistemas Linux.

Para instalar estas dependencias en una distribución basada en Debian (como Deepin, Ubuntu, etc.), ejecutar el siguiente comando:

```bash
sudo apt-get update
sudo apt-get install libxerces-c-dev libxmu-dev libmotif-dev libx11-dev
```

Si Geant4 requiere una versión de Qt, y tiene una distribución moderna, considerar usar el *flag* `-DGEANT4_USE_QT=OFF` Solo en caso de no logras instalar las librerías de Qt 4.

-----

### Pasos para Compilar y Ejecutar

Seguir estos pasos en la terminal para compilar el ejemplo B1.

#### 1\. Navegar y Preparar el Directorio

Primero, ir al directorio del ejemplo B1 y crear una carpeta separada para la compilación. Esto mantiene el código fuente limpio.

```bash
# Cambiar a la ruta de la instalación de Geant4 en su SO
cd /opt/geant4.10.06.p03/examples/basic/B1

# Crear y entrar al directorio de compilación
mkdir build
cd build
```

#### 2\. Configurar el Proyecto con CMake

Ejecutar CMake para configurar el proyecto. Este paso verifica las dependencias y genera los archivos de compilación.

Asegúrarse de reemplazar `/ruta/a/tu/instalacion/geant4` con la ruta real en el sistema.

```bash
# Configuración estándar
cmake -DGeant4_DIR=/opt/geant4.10.06.p03/lib/Geant4-10.6.3 ..

# O, si se requiere desactivar el soporte de Qt (recomendado para evitar errores de Qt)
cmake -DGeant4_DIR=/opt/geant4.10.06.p03/lib/Geant4-10.6.3 -DGEANT4_USE_QT=OFF ..
```

  * El `..` al final del comando le dice a CMake que el archivo de configuración (`CMakeLists.txt`) está en el directorio padre.

#### 3\. Compilar el Código

Una vez que CMake ha terminado (Observará los mensajes `-- Configuring done` y `-- Generating done`), puede compilar el código. La opción `-jN` (`-j4` en este caso) acelera el proceso usando múltiples núcleos del procesador.

```bash
make -j4
```

Si la compilación es exitosa, se observará el mensaje `[100%] Built target exampleB1`. El ejecutable `exampleB1` se encontrará en este mismo directorio `build`.

#### 4\. Ejecutar la Simulación

Finalmente, ejecutar el programa. Puede hacerlo de forma interactiva o pasándole un *script* de comandos para una ejecución más automatizada.

```bash
# Ejecución interactiva (abrirá una ventana de visualización si está habilitada)
./exampleB1

# O, ejecución con un script de control (por ejemplo, el que viene con el ejemplo)
./exampleB1 ../run1.mac
```

¡Felicidades\! Ha compilado y ejecutado su primer ejemplo de Geant4, superando los obstáculos comunes de dependencias.