## Flujo de trabajo completo: Simulación con Geant4 y análisis con ROOT

Este readme describe paso a paso cómo realizar una simulación de interacción de partículas con la materia usando **Geant4** y analizar los resultados con **ROOT**. Incluye la estructura de archivos, comandos y recomendaciones para un flujo de trabajo eficiente y reproducible.

### 1. Estructura del proyecto

```plaintext
ProyectoGeant4/
│
├── include/
│   └── DetectorConstruction.hh
├── src/
│   └── DetectorConstruction.cc
├── main.cc
├── CMakeLists.txt
├── vis.mac                # (opcional) Macro de visualización
├── build/                 # (se crea tras compilar)
└── README.md
```


### 2. Requisitos previos

- **Geant4** instalado y configurado.
- **ROOT** instalado para análisis posterior.
- Compilador C++ compatible (g++ recomendado).
- CMake (versión 3.5 o superior).


### 3. Paso a paso del flujo de trabajo

#### 3.1. Definición del entorno físico (Geometría y Materiales)

- Implementa la clase `DetectorConstruction` en los archivos:
    - `include/DetectorConstruction.hh`
    - `src/DetectorConstruction.cc`
- Define materiales (usando NIST o personalizados) y la geometría (volumen mundo, detectores, blancos, etc.).


#### 3.2. Configuración de la física y fuentes de partículas

- En el archivo `main.cc`, selecciona la lista de física adecuada (por ejemplo, `QGSP_BERT`).
- Implementa o selecciona el generador primario de partículas según el experimento.


#### 3.3. Implementación de acciones de usuario

- (Opcional para el flujo básico) Añade clases para gestionar la recogida de datos, como energía depositada, trayectorias, etc.


#### 3.4. Compilación del proyecto

```bash
source /ruta/a/geant4/bin/geant4.sh   # Cargar entorno Geant4
mkdir build && cd build
cmake ..
make
```


#### 3.5. Ejecución de la simulación

```bash
./Geant4Example
# o con macro de visualización
./Geant4Example vis.mac
```

- Usa la ventana gráfica para inspeccionar la geometría y verificar que los volúmenes y materiales están correctamente definidos.


#### 3.6. Almacenamiento y extracción de datos

- Implementa el almacenamiento de resultados (por ejemplo, energía depositada) usando el sistema de análisis de Geant4 (`G4AnalysisManager`).
- Guarda los datos en archivos `.root` o en archivos de texto para su posterior análisis.


#### 3.7. Análisis y visualización con ROOT

- Abre los archivos `.root` generados:

```bash
root -l
```

- En el intérprete de ROOT:

```cpp
TFile *f = TFile::Open("ejemplo.root");
TH1F *h = (TH1F*)f->Get("Edep");
h->Draw();
```

- Realiza análisis estadísticos, ajustes, sumas de histogramas y exporta gráficos según sea necesario.


### 4. Tabla resumen del flujo de trabajo

| Paso | Acción principal |
| :-- | :-- |
| Definir geometría/materiales | Crear el entorno físico de la simulación |
| Configurar física/fuentes | Seleccionar procesos y partículas |
| Programar acciones usuario | Gestionar la recogida y almacenamiento de datos |
| Compilar y ejecutar | Construir y lanzar la simulación |
| Almacenar datos | Guardar resultados en archivos ROOT |
| Analizar con ROOT | Visualizar, ajustar y procesar los datos obtenidos |

### 5. Consejos útiles

- **Visualizar la geometría** tras cada cambio para evitar errores de solapamiento o definición.
- **Automatizar** tareas repetitivas con scripts de shell o macros.
- **Documentar** los parámetros y configuraciones de cada simulación.
- **Reutilizar** macros y scripts de análisis para distintos experimentos.


### 6. Recursos adicionales

- [Documentación oficial de Geant4](https://geant4.web.cern.ch/support/user_documentation)
- [Manual de usuario de ROOT](https://root.cern/manual/)
- Foros y tutoriales de la comunidad Geant4 y ROOT

**Este flujo de trabajo es el estándar en simulaciones de física de partículas, radiación y aplicaciones médicas, permitiendo un ciclo completo desde la definición del experimento hasta el análisis avanzado de los resultados.**

