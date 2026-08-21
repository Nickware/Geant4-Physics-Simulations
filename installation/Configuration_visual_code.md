# Configuración de Visual Studio Code para Desarrollo con Geant4

Esta guía asume que **Geant4 ya está compilado e instalado** en el sistema (junto con sus datasets de física), y se enfoca exclusivamente en dejar VS Code listo como IDE completo para crear, compilar, depurar y analizar simulaciones basadas en el framework.

---

## Requisitos previos

Antes de tocar VS Code, confirma en una terminal que el entorno de Geant4 se puede cargar correctamente:

```bash
source /ruta/a/tu/instalacion/geant4/bin/geant4.sh
geant4-config --version
geant4-config --cflags
geant4-config --libs
```

Si estos comandos responden sin error, `geant4-config` es la pieza clave que usaremos más adelante para que CMake y VS Code encuentren automáticamente los headers y librerías de Geant4, sin necesidad de rutas escritas a mano.

Se asume también que ya tienes instalados: CMake (≥ 3.16), un compilador C++ (g++ o clang), ROOT (para PyROOT), Octave y Gnuplot a nivel de sistema operativo. Esta guía solo conecta esas herramientas con VS Code.

---

## 1. Extensiones necesarias en VS Code

Instala estas extensiones desde el panel de Extensiones (`Ctrl+Shift+X`) o vía terminal con `code --install-extension <id>`:

| Extensión | ID | Propósito |
|---|---|---|
| C/C++ | `ms-vscode.cpptools` | IntelliSense, navegación de código, depuración nativa |
| CMake Tools | `ms-vscode.cmake-tools` | Configurar, compilar y ejecutar proyectos CMake desde la UI |
| CMake | `twxs.cmake` | Resaltado de sintaxis para `CMakeLists.txt` |
| C/C++ Extension Pack | `ms-vscode.cpptools-extension-pack` | Empaqueta las anteriores + temas útiles |
| Python | `ms-python.python` | Necesaria para trabajar con PyROOT |
| Jupyter | `ms-toolsai.jupyter` | Notebooks interactivos para análisis con PyROOT |
| Octave | `paulober.vscode-octave` (o `fnc.octave-fnc`, según disponibilidad en tu marketplace) | Sintaxis, ejecución y linting de scripts `.m` |
| Gnuplot | `predragnikolic.gnuplot` (o `MostlyG.gnuplot-support`) | Resaltado de sintaxis para scripts `.gp`/`.plt` |
| GitLens (opcional) | `eamodio.gitlens` | Útil si el curso versiona los ejercicios con Git |

Comando de instalación rápida (ajusta los IDs si el marketplace de tu instancia difiere):

```bash
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cmake-tools
code --install-extension twxs.cmake
code --install-extension ms-python.python
code --install-extension ms-toolsai.jupyter
```

---

## 2. Variables de entorno del proyecto

En lugar de exportar variables manualmente cada vez, crea un archivo `.vscode/geant4.env` en la raíz del proyecto:

```bash
# .vscode/geant4.env
G4INSTALL=/ruta/a/tu/instalacion/geant4
PATH=${G4INSTALL}/bin:${PATH}
LD_LIBRARY_PATH=${G4INSTALL}/lib:${LD_LIBRARY_PATH}
```

Este archivo lo referenciaremos tanto desde CMake Tools como desde la terminal integrada, para que cada vez que abras el proyecto en VS Code el entorno de Geant4 esté disponible sin correr `source geant4.sh` a mano.

---

## 3. Configuración de IntelliSense (`c_cpp_properties.json`)

Crea `.vscode/c_cpp_properties.json`. Los includePath se resuelven dinámicamente vía `geant4-config`, pero como ejemplo de referencia (ajusta la ruta base a tu instalación):

```json
{
  "configurations": [
    {
      "name": "Linux-Geant4",
      "includePath": [
        "${workspaceFolder}/**",
        "/ruta/a/tu/instalacion/geant4/include/Geant4",
        "/usr/include/root"
      ],
      "defines": [],
      "compilerPath": "/usr/bin/g++",
      "cStandard": "c17",
      "cppStandard": "c++17",
      "intelliSenseMode": "linux-gcc-x64",
      "configurationProvider": "ms-vscode.cmake-tools"
    }
  ],
  "version": 4
}
```

El campo `configurationProvider` es la clave: le dice a la extensión C/C++ que delegue la resolución de includes/flags a **CMake Tools**, que a su vez los obtiene del propio `CMakeLists.txt` del proyecto (sección 6). Así evitas mantener dos fuentes de verdad para los mismos paths.

---

## 4. Configuración de CMake Tools (`settings.json`)

En `.vscode/settings.json`:

```json
{
  "cmake.configureOnOpen": true,
  "cmake.buildDirectory": "${workspaceFolder}/build",
  "cmake.generator": "Unix Makefiles",
  "cmake.environment": {
    "G4INSTALL": "/ruta/a/tu/instalacion/geant4"
  },
  "terminal.integrated.env.linux": {
    "LD_LIBRARY_PATH": "/ruta/a/tu/instalacion/geant4/lib:${env:LD_LIBRARY_PATH}"
  },
  "python.defaultInterpreterPath": "/usr/bin/python3",
  "files.associations": {
    "*.mac": "shellscript"
  }
}
```

La línea de `*.mac` es un extra útil: los archivos de macros de Geant4 (`vis.mac`, `run.mac`) no tienen resaltado propio, así que asociarlos a `shellscript` mejora bastante la legibilidad.

---

## 5. Herramientas adicionales: PyROOT, Octave y Gnuplot

### PyROOT
Si ROOT fue compilado con soporte Python, basta con que el intérprete que usa VS Code tenga visibilidad del `PYTHONPATH` de ROOT. Añade a `.vscode/settings.json`:

```json
{
  "terminal.integrated.env.linux": {
    "PYTHONPATH": "/ruta/a/tu/instalacion/root/lib:${env:PYTHONPATH}"
  }
}
```

Verifica desde la terminal integrada:

```bash
python3 -c "import ROOT; print(ROOT.gROOT.GetVersion())"
```

Con la extensión Jupyter puedes incluso analizar los `.root` generados por tus simulaciones en notebooks dentro del propio VS Code, combinando texto, gráficos y código.

### Octave
Con la extensión de Octave instalada, cualquier archivo `.m` dentro del proyecto tendrá resaltado y podrás ejecutarlo desde la terminal integrada con:

```bash
octave --no-gui script_analisis.m
```

Útil si prefieres procesar salidas CSV de Geant4 (por ejemplo, del `AnalysisManager` de los ejemplos `B4`) con Octave en vez de ROOT.

### Gnuplot
No requiere integración especial más allá del resaltado de sintaxis; se invoca directo desde la terminal integrada:

```bash
gnuplot -persist script_plot.gp
```

Puedes crear una tarea de VS Code para automatizarlo (ver sección 7).

---

## 6. Ejemplo paso a paso: `CMakeLists.txt` para un proyecto Geant4

Supongamos un proyecto simple llamado `MiSimulacion` con esta estructura:

```
MiSimulacion/
├── CMakeLists.txt
├── include/
│   ├── DetectorConstruction.hh
│   ├── PhysicsList.hh
│   └── ActionInitialization.hh
├── src/
│   ├── DetectorConstruction.cc
│   ├── PhysicsList.cc
│   └── ActionInitialization.cc
├── MiSimulacion.cc
└── macros/
    └── vis.mac
```

**Paso 1 — Encabezado y versión mínima de CMake**

```cmake
cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(MiSimulacion)
```

**Paso 2 — Localizar Geant4**

```cmake
# Busca el paquete Geant4 instalado; UI_ALL y Vis_ALL habilitan
# visualización interactiva (Qt/OpenGL) si tu build las incluye.
find_package(Geant4 REQUIRED ui_all vis_all)
```

**Paso 3 — Incluir directorios de headers**

```cmake
include(${Geant4_USE_FILE})
include_directories(${PROJECT_SOURCE_DIR}/include)
```

**Paso 4 — Recolectar fuentes y headers del proyecto**

```cmake
file(GLOB sources ${PROJECT_SOURCE_DIR}/src/*.cc)
file(GLOB headers ${PROJECT_SOURCE_DIR}/include/*.hh)
```

**Paso 5 — Definir el ejecutable**

```cmake
add_executable(MiSimulacion MiSimulacion.cc ${sources} ${headers})
target_link_libraries(MiSimulacion ${Geant4_LIBRARIES})
```

**Paso 6 — Copiar macros al directorio de build (opcional pero práctico)**

```cmake
set(MI_SIMULACION_SCRIPTS
  macros/vis.mac
)
foreach(_script ${MI_SIMULACION_SCRIPTS})
  configure_file(
    ${PROJECT_SOURCE_DIR}/${_script}
    ${PROJECT_BINARY_DIR}/${_script}
    COPYONLY
  )
endforeach()
```

**Paso 7 — Regla de instalación (opcional)**

```cmake
install(TARGETS MiSimulacion DESTINATION bin)
```

**CMakeLists.txt completo:**

```cmake
cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(MiSimulacion)

find_package(Geant4 REQUIRED ui_all vis_all)
include(${Geant4_USE_FILE})
include_directories(${PROJECT_SOURCE_DIR}/include)

file(GLOB sources ${PROJECT_SOURCE_DIR}/src/*.cc)
file(GLOB headers ${PROJECT_SOURCE_DIR}/include/*.hh)

add_executable(MiSimulacion MiSimulacion.cc ${sources} ${headers})
target_link_libraries(MiSimulacion ${Geant4_LIBRARIES})

set(MI_SIMULACION_SCRIPTS macros/vis.mac)
foreach(_script ${MI_SIMULACION_SCRIPTS})
  configure_file(
    ${PROJECT_SOURCE_DIR}/${_script}
    ${PROJECT_BINARY_DIR}/${_script}
    COPYONLY
  )
endforeach()

install(TARGETS MiSimulacion DESTINATION bin)
```

**Paso 8 — Configurar y compilar desde VS Code**

Con CMake Tools instalado, abre la paleta de comandos (`Ctrl+Shift+P`):

1. `CMake: Configure` → selecciona el kit de compilador (g++/clang) cuando se te pregunte.
2. `CMake: Build` (o el botón de compilar en la barra de estado inferior).
3. `CMake: Run Without Debugging` para ejecutar el binario resultante directamente.

---

## 7. `tasks.json` y `launch.json`

**`.vscode/tasks.json`** — tarea de build y una tarea auxiliar para lanzar Gnuplot:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Build Geant4 Project",
      "type": "shell",
      "command": "cmake --build ${workspaceFolder}/build -- -j$(nproc)",
      "group": { "kind": "build", "isDefault": true },
      "problemMatcher": ["$gcc"]
    },
    {
      "label": "Plot con Gnuplot",
      "type": "shell",
      "command": "gnuplot -persist ${file}",
      "problemMatcher": []
    }
  ]
}
```

**`.vscode/launch.json`** — depuración con GDB del ejecutable generado:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug MiSimulacion",
      "type": "cppdbg",
      "request": "launch",
      "program": "${workspaceFolder}/build/MiSimulacion",
      "args": ["macros/vis.mac"],
      "stopAtEntry": false,
      "cwd": "${workspaceFolder}/build",
      "environment": [
        { "name": "LD_LIBRARY_PATH", "value": "/ruta/a/tu/instalacion/geant4/lib" }
      ],
      "externalConsole": false,
      "MIMode": "gdb",
      "preLaunchTask": "Build Geant4 Project"
    }
  ]
}
```

Con esto, `F5` compila y arranca la simulación con breakpoints funcionales directamente sobre `DetectorConstruction.cc`, `PhysicsList.cc`, etc.

---

## 8. Verificación final

Checklist para confirmar que todo quedó conectado:

- [ ] `CMake: Configure` termina sin errores y detecta Geant4 (revisa el log: debe mostrar la versión encontrada).
- [ ] IntelliSense resuelve `#include "G4RunManager.hh"` sin subrayado rojo.
- [ ] `F5` compila y abre la ventana de visualización de Geant4 (Qt/OpenGL) si el macro la invoca.
- [ ] `python3 -c "import ROOT"` no lanza error en la terminal integrada.
- [ ] Un script `.m` se ejecuta correctamente con `octave --no-gui`.
- [ ] La tarea "Plot con Gnuplot" abre una ventana con el gráfico esperado.

Si algún paso falla, casi siempre es por `LD_LIBRARY_PATH` mal propagado a la terminal integrada — revisa primero la sección 4 antes de tocar CMake.
