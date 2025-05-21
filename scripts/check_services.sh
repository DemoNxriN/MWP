#!/bin/bash

echo "Comprobando estado de los servicios..."

services=("db" "api" "web")
all_running=true

for service in "${services[@]}"; do
  status=$(docker-compose ps -q $service | xargs docker inspect -f '{{.State.Status}}')

  if [[ "$status" != "running" ]]; then
    echo "Servicio '$service' no está activo (estado: $status)"
    all_running=false
  else
    echo "Servicio '$service' está en ejecución"
  fi
done

if $all_running; then
  echo "Todos los servicios están activos"
else
  echo "Hay servicios detenidos"
fi
