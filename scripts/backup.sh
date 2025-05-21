#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="./backups"
FILENAME="$BACKUP_DIR/db_backup_$TIMESTAMP.sql"

mkdir -p "$BACKUP_DIR"

echo "Realizando copia de seguridad de la base de datos..."

docker exec $(docker-compose ps -q db) \
  mysqldump -u root -pSJdnan4Hu59yeStSvh87gDn3hwbJr dbmwp > "$FILENAME"

if [[ $? -eq 0 ]]; then
  echo "Backup guardado en: $FILENAME"
else
  echo "Error al crear el backup"
fi
