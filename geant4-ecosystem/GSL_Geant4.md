# Ejemplo: integrar GSL con Geant4

Esta guía muestra una forma sencilla de relacionar **GSL (GNU Scientific Library)** con una aplicación de **Geant4**. La idea es usar Geant4 para simular el transporte de partículas y GSL para realizar cálculos numéricos sobre los resultados.

## Qué aporta cada herramienta

- **Geant4:** define la geometría, los materiales, las partículas, los procesos físicos y la generación de eventos.
- **GSL:** aporta algoritmos numéricos que pueden complementar la simulación, por ejemplo ajustes, integración numérica, resolución de ecuaciones y generación de distribuciones.

GSL no sustituye a los modelos físicos ni al transporte de partículas de Geant4. En este escenario, Geant4 produce los datos físicos y GSL ayuda a procesarlos o a calcular parámetros derivados.

## Caso de uso

Supongamos que una simulación registra la energía depositada en un detector para varios valores de energía inicial. Después de la ejecución, GSL puede ajustar una función lineal a esos datos para estudiar una respuesta aproximada del detector.

El flujo sería:

```text
Geant4 genera eventos -> se recopila energía depositada -> GSL ajusta los datos -> se interpretan los parámetros
```

Este análisis puede ejecutarse en una acción de usuario, aunque para un ejemplo inicial suele ser más claro hacerlo al final de la simulación o en un programa de análisis separado.

## Dependencias

Se necesitan:

- Geant4 configurado y disponible para CMake.
- GSL instalada con sus archivos de desarrollo.
- CMake y un compilador C++ compatible.

En Debian o Ubuntu, una instalación habitual es:

```bash
sudo apt update
sudo apt install libgsl-dev
```

En Fedora:

```bash
sudo dnf install gsl-devel
```

## Configuración con CMake

Partiendo de un `CMakeLists.txt` de Geant4, se puede localizar GSL y enlazarla con el ejecutable:

```cmake
find_package(Geant4 REQUIRED)
find_package(GSL REQUIRED)

include(${Geant4_USE_FILE})

add_executable(simulacion main.cc ${sources} ${headers})
target_link_libraries(simulacion
  ${Geant4_LIBRARIES}
  GSL::gsl
  GSL::gslcblas
)
```

El nombre de los targets importados puede variar según la versión o el empaquetado de GSL. Si `GSL::gsl` no está disponible, hay que revisar la configuración generada por CMake o usar las variables `GSL_INCLUDE_DIRS` y `GSL_LIBRARIES` proporcionadas por el módulo `FindGSL`.

## Ejemplo de ajuste lineal

El siguiente fragmento usa `gsl_fit_linear` para ajustar la energía depositada (`energyDeposited`) en función de la energía inicial (`initialEnergy`):

```cpp
#include <gsl/gsl_fit.h>

#include <cstddef>
#include <iostream>
#include <vector>

void fitDetectorResponse(const std::vector<double>& initialEnergy,
                         const std::vector<double>& energyDeposited)
{
    if (initialEnergy.size() != energyDeposited.size() || initialEnergy.size() < 2) {
        return;
    }

    double intercept = 0.0;
    double slope = 0.0;
    double interceptError = 0.0;
    double slopeError = 0.0;
    double covariance = 0.0;
    double chiSquared = 0.0;

    gsl_fit_linear(initialEnergy.data(), 1,
                   energyDeposited.data(), 1,
                   initialEnergy.size(),
                   &intercept, &slope,
                   &interceptError, &slopeError,
                   &covariance, &chiSquared);

    std::cout << "Intercepto: " << intercept << '\n'
              << "Pendiente: " << slope << '\n'
              << "Chi cuadrado: " << chiSquared << '\n';
}
```

En una aplicación Geant4 real, los vectores pueden llenarse a partir de la energía depositada acumulada por evento. La recolección suele pertenecer a `EventAction`, `SteppingAction` o un `SensitiveDetector`, mientras que el ajuste puede llamarse desde `RunAction` al terminar la corrida.

## Compilación y ejecución

Después de cargar el entorno de Geant4:

```bash
source /ruta/a/geant4/bin/geant4.sh
mkdir build
cd build
cmake ..
cmake --build . -j$(nproc)
./simulacion
```

## Consideraciones importantes

- Conviene separar la simulación y el análisis cuando el ajuste no necesita ejecutarse durante cada evento.
- En modo multihilo, los datos deben acumularse de forma segura. Es preferible que cada hilo mantenga sus resultados y combinarlos al final de la corrida.
- Las unidades de Geant4 deben convertirse explícitamente si GSL recibe valores en unidades del Sistema Internacional. Por ejemplo, una energía almacenada en `MeV` puede convertirse antes del ajuste.
- El ajuste numérico no valida por sí solo el modelo físico. Hay que revisar la estadística, las incertidumbres y la calidad del ajuste.
- Para histogramas, árboles y visualización de datos, ROOT sigue siendo una opción natural dentro de este repositorio; GSL resulta especialmente útil para algoritmos numéricos específicos.

## Próximos pasos

Este documento puede evolucionar hacia un ejemplo ejecutable conectado con [geant4-root](../geant4-root/), almacenando la respuesta del detector y aplicando el ajuste GSL a los datos generados por la simulación.
