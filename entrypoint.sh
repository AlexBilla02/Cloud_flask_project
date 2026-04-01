#!/bin/bash

set -e


DB_HOST="db" 
DB_PORT=5432

echo "In attesa che il database ($DB_HOST:$DB_PORT) sia pronto..."


until timeout 1s bash -c "echo > /dev/tcp/$DB_HOST/$DB_PORT" 2>/dev/null; do
  echo "...database non ancora raggiungibile, riprovo tra 1s..."
  sleep 1
done

echo "Database connesso! Procedo con le operazioni."

echo "Applicazione delle migrazioni (flask db upgrade)..."
flask db upgrade

echo "Avvio di Gunicorn..."

exec "$@"