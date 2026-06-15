#!/bin/bash
# Configuración inicial de mc
mc alias set minio http://${MINIO_SERVER}:${PORT} ${ACCES_KEY} ${SECRET_KEY} >/dev/null 2>&1

# Bucle infinito
while true: do
	start_time=$(date +%s)

	# Eliminar el archivo local si existe para evitar conflictos
	if [ -f "./input.csv" ]; then
		rm ./input.csv >/dev/null 2>&1

	fi

	#Intentar descargar el archivo
	if mc cp minio/${MINIO_BUCKET}/input.csv ./input.csv >/dev/null 2>&1; then
		# Eliminar el archivo bucket
		if mc rm minio/${MINIO_BUCKET}/input.csv >/dev/null 2>&1; then
			# Ejecutar el script de Python y permitir que su salida vaya a stdout
			python3 ./procesamiento.py
		fi
	fi

	end_time=$(date +%s)
	elapsed=$(( end_time - start_time ))
	sleep_time=$(( 60 - elapsed > 0 ? 60 - elapsed : 0 ))
done
