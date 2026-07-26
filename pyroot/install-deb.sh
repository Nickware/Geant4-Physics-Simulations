# Instalar dependencias necesarias para compilar ROOT con soporte de Python 3


#sudo apt update
#sudo apt install build-essential git libssl-dev libpcre2-dev \
               libftgl-dev default-libmysqlclient-dev libcfitsio-dev \
               libblas-dev liblapack-dev libfftw3-dev libxml2-dev \
               python3-dev python3-pip libxpm-dev libxft-dev

# Descarga del Código Fuente 

#mkdir root_install
#cd root_install
# Clonar la versión estable más reciente (ej. v6-30-06)
#git clone --branch v6-30-06 --depth 1 https://github.com/root-project/root.git root_src

# Crear y entrar al directorio de compilación:
cd root_install/root_src/build

cmake -DCMAKE_INSTALL_PREFIX=/opt/root \
      -DPYTHON_EXECUTABLE=$(which python3) \
      -DPYTHON_INCLUDE_DIR=$(python3 -c "from sysconfig import get_paths; print(get_paths()['include'])") \
      -DPYTHON_LIBRARY=$(python3 -c "import sysconfig as s; print(s.get_config_var('LIBDIR') + '/' + s.get_config_var('LDLIBRARY'))") \
      ../root_src