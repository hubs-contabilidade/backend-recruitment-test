#!/bin/bash
# Docker entrypoint script.
cd /code

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  mix ecto.create
  mix ecto.migrate
  mix ecto.seed
  echo "Database $PGDATABASE created."
fi

exec mix phx.server
