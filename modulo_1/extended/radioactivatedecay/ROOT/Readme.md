

# Guía de Análisis de Datos con ROOT en Geant4



En esta fase, se aprenderá a usar la consola interactiva de ROOT para leer y visualizar los datos generados por la simulación.



#### **1. Requisitos y Preparación**



- Asegúrarse de tener instalado y configurado el *framework* de **ROOT**.
- Verificar que el archivo `rdecay01.root` se encuentre en tu directorio de trabajo (la carpeta `build`).



#### **2. Iniciar la Sesión de ROOT y Abrir el Archivo**



1. Desde el directorio `build`, iniciar la consola de ROOT:

   Bash

   ```
   root
   ```

2. Dentro de la consola, abrir el archivo de datos:

   C++

   ```
   root [0] TFile *f = new TFile("rdecay01.root");
   ```



#### **3. Inspeccionar el Contenido del Archivo**



Para saber qué histogramas se guardaron, usar la función `ls()` del objeto `TFile`. Esto te ayudará a evitar el error de "puntero nulo" al usar nombres incorrectos.

C++

```
root [1] f->ls();
```

La salida te mostrará una lista de objetos (histogramas `TH1D` en este caso) con sus nombres, que son **números**. Por ejemplo:

```
KEY: TH1D      1;1     energy spectrum (%): e+ e-
KEY: TH1D      2;1     energy spectrum (%): nu_e anti_nu_e
KEY: TH1D      3;1     energy spectrum (%): gamma
...
```



#### **4. Obtener y Dibujar un Histograma**



Ahora que conoce los nombres exactos, puede obtener un puntero al histograma que desee y dibujarlo.

1. **Obtener el histograma**: Usar `f->Get()` y especificar el nombre correcto del histograma (ej. `"3"` para los fotones gamma).

   C++

   ```
   root [2] TH1D *h_gamma = (TH1D*)f->Get("3");
   ```

2. **Dibujar el histograma**: Usar la función `Draw()` sobre el puntero que obtuvo.

   C++

   ```
   root [3] h_gamma->Draw();
   ```

   Si el histograma no se encontrara, el puntero `h_gamma` sería nulo y `h_gamma->Draw()` causaría un fallo. El uso de `f->ls()` evita este problema.



#### 5. Próximos Pasos

Este proceso interactivo es solo el comienzo. Para un análisis más detallado, se recomienda escribir *macros* de ROOT (`.C` o `.cpp`) para automatizar el procesamiento de datos, realizar ajustes de curvas, o generar múltiples gráficos de manera programática.
