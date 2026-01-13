

## Guía: Simulación de Trayectoria en un Campo Magnético (Ejemplo B4)

Este ejemplo enseñará cómo:

1. Definir un **campo electromagnético uniforme** (o no uniforme) en el espacio.
2. Configurar el **paso de las partículas** para que el campo tenga efecto.
3. Simular el **movimiento curvo** (por ejemplo, helicoidal o parabólico) de una partícula cargada.

Aquí se tiene el paso a paso, basado en el ejemplo estándar **`B4`** de Geant4 (Basic Example 4), que está diseñado para este propósito.

### **Fase 1: Compilación y Ejecución del Ejemplo B4**

El ejemplo `B4` ya tiene la estructura de código para manejar campos, por lo que nos enfocaremos en la configuración del binario.

#### **1. Requisitos y Dependencias**

Asegúrarse de tener instalados los requisitos del sistema (**CMake**, **g++**, **Xerces-C++**, etc.), como hicimos para el ejemplo `B1`.

#### **2. Compilación del Código Fuente**

Seguir la metodología estándar de CMake.

1. Navegar al directorio del ejemplo:

   Bash

   ```
   cd /ruta/a/tu/instalacion/geant4/examples/basic/B4
   ```

2. Crear un directorio de compilación y entrar en él:

   Bash

   ```
   mkdir build
   cd build
   ```

3. Configurar el proyecto con **CMake**. (Recuerde la ruta correcta de tu Geant4).

   Bash

   ```
   cmake -DGeant4_DIR=/ruta/a/tu/instalacion/geant4/lib/Geant4-10.6.3 ..
   ```

4. Compilar el código:

   Bash

   ```
   make -j4
   ```

   Si es exitoso, se generará el ejecutable llamado **`exampleB4`**.

#### **3. Ejecución y Observación del Campo**

El ejemplo `B4` utiliza *scripts* de macro (`.mac`) para definir el campo.

1. **Ejecutar el binario** con el *script* que habilita el campo, por ejemplo, `run1.mac` o de forma interactiva.

   Bash

   ```
   ./exampleB4
   ```

2. Activar el Campo Magnético (si no lo hace el script por defecto):

   En la interfaz de Qt o en la consola interactiva, se puede definir un campo magnético uniforme de $0.5$ Tesla en la dirección $Z$.

   ```
   /globalField/setValue 0.5 tesla 0 0 0
   ```

3. **Visualizar la Geometría** y la Partícula Primaria (un positrón de $100$ MeV):

   ```
   /vis/open OGL
   /vis/drawVolume
   /run/beamOn 1
   ```

   Debera ver la trayectoria del positrón curvándose en el campo magnético.

------

### **Fase 2: Personalización del Modelo (El Código Clave)**

Para entender cómo se modela el campo, se debe observar las dos clases clave en el código fuente de Geant4.

#### **1. Definición del Campo (Clase: `B4DetectorConstruction.cc`)**

El campo se define en el archivo de construcción del detector.

- **¿Qué hace?** Esta clase crea y configura un objeto que representa el campo (por ejemplo, `G4UniformMagField` para un campo uniforme) y lo asigna al espacio físico (al "mundo" o a un volumen específico).

- **Código clave (Conceptual):**

  C++

  ```
  // 1. Crear el objeto del campo magnético (ej. 0.5 Tesla en Z)
  G4MagneticField* magField = new G4UniformMagField(G4ThreeVector(0.5*tesla, 0.0, 0.0));
  
  // 2. Definir la región de la física que será afectada (Todo el mundo)
  G4FieldManager* fieldMgr = G4TransportationManager::GetTransportationManager()->GetFieldManager();
  fieldMgr->SetDetectorField(magField);
  fieldMgr->CreateChordFinder(magField);
  ```



#### **2. Movimiento y Paso (Clase: `G4PropagatorInField`)**

Geant4 no utiliza las ecuaciones analíticas del movimiento (como $r = p / (qB)$). En su lugar, usa un método numérico para simular la trayectoria, el cual está controlado por el **paso máximo** y la **precisión** del integrador.

- **Integrador Numérico:** El `G4FieldManager` utiliza un integrador (como **Runge-Kutta 4th order**) para resolver numéricamente la ecuación de Lorentz:

  $\frac{d\mathbf{p}}{dt} = q(\mathbf{E} + \mathbf{v} \times \mathbf{B})$

- **Ajuste de la Precisión:** El campo magnético puede curvar drásticamente las trayectorias. Para que Geant4 no falle o genere resultados inexactos, es crucial ajustar el **tamaño máximo del paso** en el campo (`G4ChordFinder`). En Geant4, esto se hace en la `B4DetectorConstruction.cc` o en un *macro* de configuración:

  C++

  ```
  // Define la precisión (paso máximo) para el seguimiento en el campo
  G4double maxStep = 1.0 * mm; 
  G4UserLimits* userLimits = new G4UserLimits(maxStep);
  
  // Asigna el límite al volumen donde existe el campo
  logVolumen->SetUserLimits(userLimits);
  ```

**Resumen:** El módulo 1 debe enfocarse en cómo se define el vector de campo (`G4UniformMagField`) y cómo se utiliza `G4FieldManager` para activar la simulación del movimiento en ese campo. Esto proporciona una base excelente para entender el transporte de partículas en simulaciones realistas.
