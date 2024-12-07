#!/bin/bash

HOST=${1:-"apim_nodo1"}  # Host a verificar (predeterminado: apim_nodo1)
PORT=${2:-"9443"}        # Puerto a verificar (predeterminado: 9443)
SERVICE_CMD=${3:-""}     # Comando opcional para iniciar un servicio después de la espera
TIMEOUT=300              # Tiempo máximo de espera en segundos
WAIT_INTERVAL=5          # Intervalo de espera entre intentos

echo "Esperando a que $HOST esté listo en el puerto $PORT..."

# Verificar conectividad al puerto
START_TIME=$(date +%s)
while ! (echo > /dev/tcp/$HOST/$PORT) 2>/dev/null; do
  sleep $WAIT_INTERVAL
  echo "El puerto $PORT de $HOST aún no está listo..."
  ELAPSED_TIME=$(($(date +%s) - $START_TIME))
  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "Error: Tiempo de espera excedido ($TIMEOUT segundos) para $HOST:$PORT"
    exit 1
  fi
done

echo "$HOST:$PORT está listo."

# Si se proporciona un comando de servicio, ejecutarlo
if [ -n "$SERVICE_CMD" ]; then
  echo "Iniciando servicio con el comando: $SERVICE_CMD"
  eval $SERVICE_CMD
fi