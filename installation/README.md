# Instalación del entorno Geant4 y ROOT

Esta carpeta reúne documentación y scripts de Bash para preparar un entorno de desarrollo científico con **Geant4**, **ROOT**, **PyROOT** y sus dependencias. Los scripts tienen distintos alcances: uno instala la pila completa en sistemas Debian, otro compila Geant4 en Fedora/RHEL y otro instala paquetes generales del sistema.

## Seleccionar el instalador

| Sistema o necesidad | Script recomendado | Resultado |
| --- | --- | --- |
| Debian, Ubuntu o Deepin | `script_install_debian_users.sh` | Instala dependencias, Geant4 y ROOT con PyROOT |
| Fedora, RHEL, Rocky, AlmaLinux o CentOS | `script_install_fedora_users.sh` | Instala dependencias y compila Geant4 |
| Paquetes generales en Fedora/RHEL | `script_essencials.sh` | Instala herramientas generales y paquetes multimedia |

Los scripts no son intercambiables: el instalador Debian compila también ROOT, mientras que el instalador Fedora/RHEL no instala ROOT.

## Estructura por componentes

Los instaladores principales delegan en scripts más pequeños organizados por sistema operativo:

```text
installation/
|-- debian/
|   |-- install_dependencies.sh
|   |-- install_geant4.sh
|   |-- install_root.sh
|   `-- configure_environment.sh
|-- fedora/
|   |-- install_dependencies.sh
|   `-- install_geant4.sh
|-- config/
|   `-- versions.env
|-- guides/
|   |-- debian-geant4.md
|   `-- fedora-geant4.md
|-- script_install_debian_users.sh
|-- script_install_fedora_users.sh
`-- script_essencials.sh
```

Los scripts ubicados directamente en `installation/` se mantienen como puntos de entrada compatibles. Para instalaciones nuevas se pueden ejecutar los componentes directamente y repetir solo la etapa necesaria.

## Guías paso a paso

- [`guides/debian-geant4.md`](guides/debian-geant4.md): instalación manual y automatizada en Debian, Ubuntu y Deepin, incluyendo Geant4, ROOT y PyROOT.
- [`guides/fedora-geant4.md`](guides/fedora-geant4.md): instalación en Fedora y sistemas RHEL mediante `dnf` o `yum`.

El README funciona como índice y referencia de configuración; no repite el procedimiento completo. Las guías contienen los pasos manuales, automatizados y con Distrobox. Los scripts automatizan las etapas repetitivas y usan los valores fijados en `config/versions.env`.

## Versiones y rutas centralizadas

El archivo [`config/versions.env`](config/versions.env) define las versiones y ubicaciones predeterminadas de la pila:

- Geant4 `11.2.1`.
- ROOT `v6-30-06`.
- Geant4 en `/opt/geant4`.
- ROOT en `/opt/root`.
- Fuentes y compilaciones en `/var/tmp/geant4-physics-install`.

Para cambiar una versión o una ruta, edita este archivo antes de instalar. También se pueden proporcionar variables de entorno para una ejecución puntual, por ejemplo:

```bash
sudo env G4_VERSION=11.2.1 G4_PREFIX=/opt/geant4 ./debian/install_geant4.sh
sudo env ROOT_BRANCH=v6-30-06 ROOT_INSTALL_PREFIX=/opt/root ./debian/install_root.sh
```

No se usa `latest-stable`: fijar una etiqueta concreta permite repetir la instalación y saber qué versión se probó.

## Scripts incluidos

### `script_install_debian_users.sh`

Instala la pila completa en distribuciones basadas en Debian:

- dependencias de compilación, Qt, OpenGL, GDML y Python;
- Geant4 `11.2.1` en `/opt/geant4`;
- ROOT desde la etiqueta `v6-30-06` en `/opt/root`;
- soporte de PyROOT;
- configuración del entorno mediante `/etc/profile.d/geant4-root.sh`.

Requiere `apt`, acceso a Internet, espacio suficiente para compilar ambos proyectos y permisos para instalar paquetes y escribir en `/opt`.

### `script_install_fedora_users.sh`

Prepara y compila Geant4 en sistemas de la familia Fedora/RHEL:

- detecta `dnf` o `yum`;
- instala dependencias de Qt, X11, Motif, OpenGL y GDML;
- solicita la ruta de instalación, la carpeta temporal y la URL del código fuente;
- descarga y extrae un archivo `.zip`, `.tar.gz` o `.tgz`;
- configura Geant4 con CMake y lo compila usando todos los núcleos disponibles;
- registra paquetes instalados y fallidos.

Este script instala Geant4, pero no instala ROOT ni configura automáticamente el entorno del usuario.

### `script_essencials.sh`

Instala paquetes generales en Fedora y sistemas de la familia RHEL. Puede configurar EPEL y RPM Fusion e instala herramientas como `wget`, `curl`, `unzip`, compiladores, paquetes multimedia, Java y utilidades del sistema.

Este script no compila Geant4 ni ROOT. Es opcional y sirve como preparación general del sistema.

## Requisitos generales

- Leer el script y confirmar sus rutas antes de ejecutarlo.
- Tener una conexión a Internet funcional.
- Disponer de varios gigabytes libres para las fuentes, la compilación y la instalación.
- Usar una distribución compatible con el gestor de paquetes del script.
- Ejecutar con privilegios suficientes para instalar paquetes y escribir en las rutas elegidas.
- Revisar los mensajes y logs aunque el script finalice correctamente.

Los scripts actuales no ofrecen todavía un modo `--dry-run` ni selección de componentes. La instalación completa puede tardar bastante, especialmente al compilar Geant4 y ROOT.

## Archivos de log

Los scripts Fedora/RHEL crean en el directorio desde el que se ejecutan:

- `paquetes_instalados.log`: salida de las instalaciones exitosas.
- `paquetes_fallidos.log`: paquetes que no pudieron instalarse y resultados de búsqueda de alternativas.

Estos archivos se sobrescriben al comenzar una nueva ejecución. Conviene copiarlos o renombrarlos antes de repetir una instalación.

## Ejecución

Desde la carpeta `installation/`, en Fedora/RHEL, para instalar Geant4:

```bash
sudo ./script_install_fedora_users.sh
```

Para la preparación general del sistema:

```bash
sudo ./script_essencials.sh
```

En Debian/Ubuntu/Deepin:

```bash
sudo ./script_install_debian_users.sh
```

También es posible ejecutar cada etapa Debian por separado:

```bash
sudo ./debian/install_dependencies.sh
sudo ./debian/install_geant4.sh
sudo ./debian/install_root.sh
sudo ./debian/configure_environment.sh
```

En Fedora/RHEL, las etapas equivalentes son:

```bash
sudo ./fedora/install_dependencies.sh
sudo ./fedora/install_geant4.sh
```

Actualmente no hay un instalador Fedora/RHEL separado para ROOT; el script Fedora instala únicamente Geant4.

El instalador Debian crea `/etc/profile.d/geant4-root.sh` y no modifica `.bashrc`. Abre una terminal nueva o ejecuta `source /etc/profile.d/geant4-root.sh` para cargar el entorno. La ubicación puede cambiarse con `ENVIRONMENT_FILE`.

## Verificación rápida

Después de instalar Geant4 y cargar su entorno, comprueba la versión y la ruta:

```bash
geant4-config --version
geant4-config --prefix
```

Si necesitas el procedimiento completo o el diagnóstico de un error, consulta la guía de tu distribución. Ambas guías incluyen también un flujo aislado mediante Distrobox.

## Documentación relacionada

- [`Configuration_visual_code.md`](Configuration_visual_code.md): configuración de VS Code para proyectos Geant4.
- [`Root.md`](Root.md): notas sobre la instalación y configuración de ROOT.
- [`example.txt`](example.txt): ejemplos y comandos auxiliares de instalación.


