# Guía de Análisis de Datos con ROOT en Geant4 

Este guía sugiere el proceso de lectura y análisis de los archivos de salida `.root` generados por en los ejemplos de Geant4. Para esta documento se empleará `rdecay01`. Aprenderá a usar el entorno de **ROOT** para visualizar histogramas de forma interactiva y evitar los errores comunes que surgen al intentar acceder a los datos.

-----

### Requisitos Previos

  * Para este documento, kaber compilado y ejecutado el ejemplo `rdecay01` de Geant4.
  * Tener instalado y configurado el *framework* de ROOT.
  * Haber generado un archivo de salida de la simulación, como por ejemplo **`run1.root`**.

-----

### Pasos para el Análisis Interactivo con ROOT

Seguir estos pasos en su terminal para iniciar el análisis de datos.

#### 1\. Iniciar la Sesión de ROOT

Primero, asegúrarse de estar en el directorio donde se generó el archivo `.root` (`build` o el directorio principal del ejemplo) y ejecutar el comando `root` para iniciar la consola interactiva.

```bash
root
```

#### 2\. Abrir el Archivo de Datos

Dentro de la consola de ROOT, abrir el archivo de datos de la simulación. En este caso, se empleará `run1.root`, que contiene los resultados de una ejecución simple.

```cpp
root [0] TFile *f = new TFile("run1.root");
```

#### 3\. Inspeccionar el Contenido del Archivo

Para saber qué datos están disponibles en el archivo, usar el comando `ls()`. Esto mostrará una lista de todos los objetos (histogramas, árboles, etc.) que se guardaron durante la simulación, junto con sus nombres.

```cpp
root [1] f->ls();
```

La salida debería ser similar a esta:

```
TFile** run1.root
 TFile* run1.root
  KEY: TH1D      1;1     energy spectrum (%): e+ e-
  KEY: TH1D      2;1     energy spectrum (%): nu_e anti_nu_e
  KEY: TH1D      3;1     energy spectrum (%): gamma
  KEY: TH1D      5;1     energy spectrum (%): ions
  KEY: TH1D      6;1     total kinetic energy per single decay (Q)
  KEY: TH1D      7;1     momentum balance
  KEY: TH1D      8;1     total time of life of decay chain
```

**¡Importante\!** Los nombres de los objetos son los números que aparecen al lado de `KEY: TH1D`. Por ejemplo, el histograma del espectro de energía de los fotones (gamma) tiene el nombre **`"3"`**. Usar un nombre incorrecto (como `h3`) provocará un error de puntero nulo.

#### 4\. Obtener y Dibujar un Histograma

Ahora que se conocen los nombres exactos, se puede obtener un histograma del archivo y dibujarlo en la pantalla.

1.  **Obtener el objeto del histograma:** Usar la función `f->Get()` para obtener el puntero al histograma. Deberá usar el nombre que encontró con `f->ls()`.

    ```cpp
    // Obtener el histograma del espectro de energía de los fotones
    root [2] TH1D *h_gamma = (TH1D*)f->Get("3");
    ```

2.  **Verificar y Dibujar:** Es una buena práctica verificar que el puntero no sea nulo antes de intentar dibujar. Esto evita que la sesión de ROOT se bloquee. Luego, usar la función `Draw()`.

    ```cpp
    root [3] if (h_gamma) { h_gamma->Draw(); } else { cout << "Histograma '3' no encontrado." << endl; }
    ```

Repitir el paso 4 para cualquier otro histograma que desee visualizar, reemplazando el nombre (`"3"`) por el número correspondiente. Por ejemplo, para el espectro de electrones y positrones, usar el nombre `"1"`.

-----

### Próximos Pasos

Este proceso interactivo es solo el comienzo. Para un análisis más detallado, se recomienda escribir *macros* de ROOT (`.C` o `.cpp`) para automatizar el procesamiento de datos, realizar ajustes de curvas, o generar múltiples gráficos de manera programática.