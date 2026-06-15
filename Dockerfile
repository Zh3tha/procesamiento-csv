FROM ubuntu:jammy

# Instalar Python y pandas, limpiar caché
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl && \
    curl https://dl.min.io/client/mc/release/linux-amd64/mc \
      --create-dirs -o /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc && \
    pip3 install pandas && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Crear un usuario no privilegiado con UID y GID 1000
RUN groupadd -g 1000 appuser &&\
	useradd -m -u 1000 -g appuser appuser

# Crear directorio /app y establecer los permisos adecuados
RUN mkdir /app &&\
	chown appuser:appuser /app

# Copiar los scripts al contenedor en el directorio /app
COPY procesamiento.py /app/procesamiento.py
#COPY entrypoint.sh /app/entrypoint.sh

# Cambiar la propiedad de los scripts al nuevo usuario y dar permisos de ejecución
RUN chown appuser:appuser /app/procesamiento.py #&&\
	#chown +x /app/entrypoint.sh
#/app/entrypoint.sh
# Cambiar al usuario no privilegiado
USER appuser

# Establecer el directorio de trabajo en /app
WORKDIR /app

# Configurar el script de entrada como el punto de entrada del contenedor
#ENTRYPOINY ["./entrypoint.sh"]
