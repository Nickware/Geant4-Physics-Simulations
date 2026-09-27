# Simulación Computacional en Física

Este repositorio alberga el material del curso Simulación Computacional en Física enmarcado en Electromagnetismo, Física Moderna y Nuclear con Métodos Monte Carlo.

---

## Descripción General del Curso

El curso brinda una inmersión profunda y práctica en la simulación de la interacción de partículas con la materia. Combinando una sólida base teórica con habilidades computacionales avanzadas, se centra en la aplicación de métodos Monte Carlo utilizando el potente toolkit **Geant4** y la suite de análisis de datos **ROOT**, programando en **C++**.

Los estudiantes explorarán los principios fundamentales del electromagnetismo, la física moderna y la física nuclear desde una perspectiva computacional. Aprenderán a diseñar, implementar y analizar simulaciones complejas, cruciales en:

- Física de altas energías
- Física médica
- Ciencia espacial
- Protección radiológica
- Física nuclear aplicada

---

## Objetivos de Aprendizaje Clave

Al finalizar el curso, los participantes serán capaces de:

- Comprender y aplicar los principios físicos que rigen la interacción de partículas con materiales diversos.
- Dominar los fundamentos y la aplicación práctica de los métodos **Monte Carlo** para resolver problemas estocásticos en física.
- Desarrollar y optimizar aplicaciones de simulación en **C++**, empleando Programación Orientada a Objetos.
- Construir y configurar geometrías de detectores y entornos experimentales complejos usando **Geant4**.
- Ejecutar simulaciones de transporte de partículas en **Geant4**, seleccionando y personalizando modelos físicos (electromagnéticos y hadrónicos).
- Analizar y visualizar datos generados por las simulaciones mediante el framework **ROOT**.
- Interpretar los resultados de las simulaciones, relacionándolos con la teoría física y evaluando incertidumbres y limitaciones.

---

## Temas Principales Cubiertos

El programa está estructurado en los siguientes módulos:

- **Fundamentos de C++:**  
  Repaso y profundización en POO, gestión de memoria y uso de librerías estándar.
- **Métodos Monte Carlo:**  
  Generación de números aleatorios, muestreo de distribuciones, integración Monte Carlo y técnicas de reducción de varianza.
- **Electromagnetismo en Geant4:**  
  Procesos EM clave (ionización, bremsstrahlung, Compton, fotoeléctrico, etc.) y su configuración en Geant4.
- **Física Moderna y Relativista:**  
  Cinemática de partículas y fenómenos como la radiación Cherenkov.
- **Física Nuclear y Hadrónica en Geant4:**  
  Decaimientos radiactivos (G4RadioactiveDecay), interacción de neutrones y modelos hadrónicos.
- **Análisis de Datos con ROOT:**  
  Herramientas para lectura, procesamiento, visualización y ajuste de datos provenientes de simulaciones.

---

## Organización del Repositorio

El repositorio sigue el flujo completo de trabajo de una simulación: preparar el entorno, construir una aplicación Geant4, ejecutar un proceso físico y analizar los resultados.

- **[installation/](installation/):** instrucciones y scripts para instalar y configurar Geant4, ROOT y sus dependencias en distribuciones basadas en Debian y Fedora.
- **[geant4-root/](geant4-root/):** proyecto base que integra Geant4 y ROOT. Incluye la definición de la geometría, la configuración con CMake, la visualización y el almacenamiento de resultados.
- **[modulo_1/Basic/B1/](modulo_1/Basic/B1/):** primer ejercicio práctico de Geant4, centrado en compilar y ejecutar una simulación sencilla del paso de una partícula por un detector.
- **[modulo_1/Basic/B4/](modulo_1/Basic/B4/):** ejercicio sobre el movimiento de partículas cargadas en un campo magnético y el seguimiento numérico de sus trayectorias.
- **[modulo_1/extended/radioactivatedecay/rdecay01/](modulo_1/extended/radioactivatedecay/rdecay01/):** aplicación de física nuclear para simular decaimientos radiactivos y producir datos de salida en formato ROOT.
- **[modulo_1/Basic/ROOT/](modulo_1/Basic/ROOT/):** guía para abrir, inspeccionar y visualizar con ROOT los histogramas generados por las simulaciones, especialmente `rdecay01`.
- **[pyroot/](pyroot/):** instalación y configuración de ROOT con soporte para Python mediante PyROOT, ampliando las posibilidades de análisis y automatización.
- **[geant4-examples-guide/](geant4-examples-guide/):** catálogo de referencia de los ejemplos básicos, extendidos y avanzados incluidos en Geant4.
- **[geant4-ecosystem/](geant4-ecosystem/):** tecnologías que complementan Geant4, como GATE, TOPAS, GDML, DICOM, Qt y herramientas para computación de alto rendimiento.

## Ruta de Aprendizaje y Flujo de Trabajo

Se recomienda avanzar por el repositorio en este orden:

1. Preparar las dependencias siguiendo las instrucciones de **`installation/`**.
2. Repasar la estructura de una aplicación Geant4 con **`geant4-root/`**.
3. Comenzar con el ejemplo **B1** y continuar con **B4** para introducir campos y trayectorias.
4. Estudiar **`rdecay01`** como aplicación de física nuclear y generar sus archivos `.root`.
5. Analizar esos resultados con la guía de **ROOT** o mediante **PyROOT**.
6. Consultar **`geant4-examples-guide/`** y **`geant4-ecosystem/`** para explorar aplicaciones más avanzadas.

Este recorrido conecta los objetivos teóricos del curso con un ciclo reproducible de trabajo:

```text
Instalación -> compilación -> simulación -> generación de datos -> análisis -> ampliación
```

---

## Audiencia

Este curso está dirigido a estudiantes de posgrado o de último año de grado en:

- Física
- Ingeniería nuclear
- Ingeniería biomédica
- Ciencia de materiales
- Áreas afines

Requisito: Tener conocimientos previos de física general y programación básica en C++.
