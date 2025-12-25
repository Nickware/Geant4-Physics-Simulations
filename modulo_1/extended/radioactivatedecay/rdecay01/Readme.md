# Ejercicio Práctico: Ejecutando el ejemplo extented rdecay01 de Geant4



Este ejercicio guiará a través  del proceso de simulación para el ejemplo **`rdecay01`** de Geant4. Se aprenderá a compilar el código fuente, ejecutar la simulación de decaimiento exponencial.

------



### **Ejecutando el Ejemplo extented rdecay01 de Geant4**



Esta fase cubre la compilación y ejecución de la simulación. El objetivo es generar un archivo binario ejecutable y un archivo de datos `.root` para el análisis posterior.



#### **1. Requisitos y Dependencias**



Asegúrarse de tener instalados los siguientes programas y librerías de desarrollo en el sistema. Estos son los componentes más comunes que causan errores de compilación.

- **Geant4**: Versión 10.6.p03 o superior.
- **CMake**: Versión 3.10 o superior.
- **Compilador de C++**: Por ejemplo, `g++`.
- **Librerías de desarrollo**: Para evitar errores de enlazado, instala las siguientes librerías:
  - **Xerces-C++** para el soporte de GDML.
  - **X11** y **Motif** para la visualización.

En distribuciones basadas en Debian (como Deepin, Ubuntu, etc.), puede instalarla con la siguiente instrucción:

Bash

```
sudo apt-get update
sudo apt-get install libxerces-c-dev libxmu-dev libmotif-dev libx11-dev
```



#### **2. Compilación del Código Fuente**



Seguir estos pasos para compilar la simulación. Es una buena práctica usar un directorio de compilación separado del código fuente.

1. Navegar al directorio del ejemplo `rdecay01`:

   Bash

   ```
   cd /ruta/a/su/instalacion/geant4/examples/extended/radioactivedecay/rdecay01
   ```

2. Crear un directorio de compilación y entra en él:

   Bash

   ```
   mkdir build
   cd build
   ```

3. Configurar el proyecto con **CMake**. Asegúrarse de apuntar al directorio de su instalación de Geant4.

   Bash

   ```
   cmake -DGeant4_DIR=/ruta/a/tu/instalacion/geant4/lib/Geant4-10.6.3 ..
   ```

   *Nota*: Si encuentra errores relacionados con Qt, intentar desactivar la visualización con el *flag* `-DGEANT4_USE_QT=OFF`.

4. Compilar el código. Utilizar la opción `-j` con el número de núcleos de tu CPU para acelerar el proceso.

   Bash

   ```
   make -j4
   ```

   Si la compilación es exitosa, verá el mensaje **`[100%] Built target rdecay01`**. El ejecutable `rdecay01` se encontrará en este mismo directorio `build`.



#### **3. Ejecución de la Simulación**



Una vez compilado, ejecutar el binario. El ejemplo `rdecay01` utiliza un archivo de *script* (`run1.mac`) para definir la simulación, como el isótopo a decaer y el número de eventos.

Bash

```
./rdecay01 ../run1.mac
```

Esta ejecución generará un archivo de salida llamado **`rdecay01.root`** en el directorio `build`. Este archivo contendrá todos los datos para el análisis.

Se ha completado el ciclo de trabajo de simulación, desde la compilación del código hasta la ejecución de la simulación.
