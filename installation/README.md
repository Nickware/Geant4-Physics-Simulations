# Automatización de Instalación de Paquetes en Fedora

Este repositorio contiene dos scripts de Bash diseñados para facilitar la instalación de paquetes y dependencias en sistemas **Fedora Linux**. Uno está orientado a la configuración general y multimedia del sistema, y el otro automatiza la preparación del entorno para la instalación de **Geant4** (un toolkit para la simulación de partículas en física).

---

## Scripts Incluidos

### 1. `instalador_fedora.sh`

#### Funcionalidad
- Automatiza la instalación de un conjunto amplio de paquetes útiles para usuarios de Fedora (multimedia, utilitarios, desarrollo, idiomas, etc.).
- Agrega y configura los repositorios más populares: **EPEL** y **RPM Fusion** (free y nonfree). También intenta agregar **ElRepo** de forma opcional.
- Actualiza el sistema antes de instalar los paquetes.
- Registra en dos archivos de log:
  - `paquetes_instalados.log`: Paquetes instalados exitosamente.
  - `paquetes_fallidos.log`: Paquetes que han fallado o no se han encontrado (incluye sugerencias alternativas).

#### Flujo de Uso
1. **Verifica ejecución como root.**
2. **Configura y actualiza repositorios.**
3. **Actualiza el sistema.**
4. **Instala una lista predefinida de paquetes, registrando el estado de cada uno.**
5. **Ofrece un resumen y la consulta de los archivos de log al finalizar.**

#### Beneficios
- Facilita la puesta a punto de Fedora tras una instalación limpia.
- Permite auditar fácilmente los errores y soluciones propuestas.
- Adaptable a otras listas de paquetes según las necesidades del usuario.

---

### 2. `instalador_geant4_fedora.sh`

#### Funcionalidad
- Automatiza la instalación de **todas las dependencias recomendadas por Geant4** para el entorno de desarrollo y visualización en Fedora.
- Añade **EPEL** y **ElRepo** para ampliar la disponibilidad de paquetes.
- Verifica la presencia de cada paquete antes de intentar su instalación y, si no está disponible, lo registra junto a sugerencias de nombres similares.
- Solicita al usuario información clave para la instalación de Geant4:
  - Ruta de instalación.
  - Carpeta temporal de trabajo (descarga y compilación).
  - Link de descarga del código fuente.
  - Directorio de build y ruta del código fuente extraído.
- Automatiza el proceso de compilación y hace uso de todos los núcleos del sistema disponibles.
- Registra:
  - `paquetes_faltantes.log`: Paquetes que no se pudieron instalar.
  - `sugerencias_paquetes.log`: Paquetes alternativos sugeridos según coincidencia de nombre.

#### Flujo de Uso
1. **Actualiza y configura repositorios.**
2. **Instala y verifica dependencias esenciales para Geant4, registrando alternativas si hay fallos.**
3. **Solicita interactivamente parámetros para la instalación personalizada de Geant4.**
4. **Descarga, descomprime, configura y compila Geant4 con soporte para visualización y utilización de recursos multicore.**
5. **Reporta fallos de dependencias al usuario al finalizar.**

#### Beneficios
- Automatiza completamente el entorno recomendado por el manual oficial de Geant4.
- Ahorra pasos manuales y reduce errores.
- Transparencia total ante cualquier problema de dependencias o paquetes ausentes.

---

## Requisitos Generales

- Ambos scripts deben ejecutarse con privilegios de **root** (`sudo` o como superusuario).
- Requieren una conexión a Internet funcional.
- Probados sobre versiones recientes de Fedora (ajuste esperado para futuros releases).

---

## Archivos de Log

Cada script deja archivos de log claros que ayudan:
- A identificar paquetes instalados correctamente.
- A ubicar errores y encontrar alternativas sugeridas para solucionar problemas de dependencias.

---

## Ejecución

```bash
sudo ./instalador_fedora.sh
```
o

```bash
sudo ./instalador_geant4_fedora.sh
```

## Licencia

Uso libre bajo licencia MIT o similar.

---

¡Este script automatiza el entorno Fedora, de manera segura y eficiente empleando Geant4 Y ROOT!


