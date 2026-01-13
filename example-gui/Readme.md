# Guía de ejemplo en Geant4

Geant4 organiza sus ejemplos en tres grandes categorías según su complejidad y propósito. 

Todos los ejemplos se encontraran en el directorio `examples/`:

------

## 1. Ejemplos Básicos (`basic/`)

Diseñados para principiantes. Cubren las funcionalidades esenciales de Geant4 (geometría, partículas, procesos físicos básicos y extracción de datos).

- **B1:** Geometría simple, conteo de dosis en un volumen.
- **B2:** Rastreo de partículas en un campo magnético con geometrías segmentadas.
- **B3:** Aplicación médica simple (similar a un PET) con fuentes radiactivas.
- **B4:** Un calorímetro de muestreo que enseña a usar el `AnalysisManager` (ROOT, CSV).
- **B5:** Una configuración completa: cámara de hilos, calorímetros y lógica de *trigger*.

------

## 2. Ejemplos Extendidos (`extended/`)

Esta es la sección más grande. Están agrupados por módulos específicos de física o computación:

### Física Electromagnética (`electromagnetic/`)

- **TestEm1 - TestEm18:** Pruebas detalladas de deposición de energía, rangos y secciones eficaces.
- **DNA:** Simulaciones de daño biológico a nivel nanométrico (procesos de física química).
- **Polarización:** Procesos con haces polarizados.

### Física Hadrónica (`hadronic/`)

- **Hadr01 - Hadr10:** Cascadas hadrónicas, procesos de fisión, captura de neutrones y secciones eficaces.
- **NeutronSource:** Generación de neutrones en blancos.

### Física de Campos y Óptica (`field/` y `optical/`)

- **Field01 - Field06:** Movimiento en campos magnéticos, eléctricos y gravitacionales.
- **LXe / OpNovice:** Simulación de centelladores, fibras ópticas y efecto Cherenkov.

### Análisis y Geometría (`analysis/` y `geometry/`)

- **GDML:** Cómo importar/exportar geometrías desde archivos XML.
- **Parallel:** Uso de "mundos paralelos" (geometrías superpuestas).
- **RE01 - RE07:** Técnicas avanzadas de puntuación (*scoring*) y lecturas de detectores.

### Otros módulos relevantes

- **Biasing:** Técnicas de reducción de varianza para simulaciones largas.
- **RadioactiveDecay:** Como el `rdecay01` que usamos, enfocado en cadenas de decaimiento e isótopos.
- **Medical:** Aplicaciones de radioterapia y dosimetría (DICOM).

------

## 3. Ejemplos Avanzados (`advanced/`)

Estos son proyectos casi de nivel de investigación real, a menudo mantenidos por instituciones externas:

| **Ejemplo**             | **Aplicación**                                               |
| ----------------------- | ------------------------------------------------------------ |
| **brachytherapy**       | Tratamiento de cáncer mediante fuentes insertadas (Braquiterapia). |
| **hadrontherapy**       | Simulación de centros de protonterapia o terapia de iones.   |
| **human_phantom**       | Modelado de órganos humanos según la ICRP para protección radiológica. |
| **microdosimetry**      | Simulación de efectos de radiación en células individuales.  |
| **underground_physics** | Búsqueda de materia oscura y fondo de radiación en laboratorios subterráneos. |
| **gammaray_telescope**  | Simulación de un telescopio espacial de rayos gamma.         |
| **STCyclotron**         | Producción de radioisótopos en un ciclotrón.                 |

------

## Resumen de Uso

Si se necesita aprender algo específico, buscar así:

1. **¿Conceptos base?** Ve a `basic/`.
2. **¿Un proceso físico puntual (ej. efecto fotoeléctrico)?** Ve a `extended/electromagnetic/`.
3. **¿Una aplicación médica o espacial completa?** Ve a `advanced/`.

