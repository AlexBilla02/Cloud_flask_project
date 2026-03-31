#!/bin/bash

set -e

echo "Wait for database..."
# (Opzionale) Qui si potrebbe aggiungere un loop per testare la porta 5432
sleep 5 

echo "Applying database migrations..."
flask db upgrade

echo "Starting Gunicorn..."
exec gunicorn -w 4 -b 0.0.0.0:8080 wsgi:app