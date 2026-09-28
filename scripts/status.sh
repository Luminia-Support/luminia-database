#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
cd "$DIR"

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-luminia_db3}"
DB_USER="${DB_USER:-luminia-admin}"
DB_PASSWORD="${DB_PASSWORD:-luminia-admin}"
CHANGELOG_FILE="${CHANGELOG_FILE:-changelog/db.changelog-master.yaml}"

echo "======================================================"
echo " [Luminia Database] ESTADO DE MIGRACIONES"
echo " Base de Datos : ${DB_HOST}:${DB_PORT}/${DB_NAME}"
echo "======================================================"

if command -v liquibase >/dev/null 2>&1; then
    liquibase \
        --url="jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}" \
        --username="${DB_USER}" \
        --password="${DB_PASSWORD}" \
        --changelog-file="${CHANGELOG_FILE}" \
        status --verbose
elif command -v docker >/dev/null 2>&1; then
    DOCKER_DB_HOST="$DB_HOST"
    if [ "$DB_HOST" = "localhost" ] || [ "$DB_HOST" = "127.0.0.1" ]; then
        DOCKER_DB_HOST="host.docker.internal"
    fi
    docker run --rm \
        --network="host" \
        -v "${DIR}/changelog:/liquibase/changelog" \
        -v "${DIR}/config:/liquibase/config" \
        liquibase/liquibase:4.27-alpine \
        --url="jdbc:postgresql://${DOCKER_DB_HOST}:${DB_PORT}/${DB_NAME}" \
        --username="${DB_USER}" \
        --password="${DB_PASSWORD}" \
        --changelog-file="changelog/db.changelog-master.yaml" \
        status --verbose
else
    echo "ERROR: Se requiere 'liquibase' CLI instalado o 'docker'."
    exit 1
fi
