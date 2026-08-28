#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
cd "$DIR"

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-luminia_db}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-postgres}"
CHANGELOG_FILE="${CHANGELOG_FILE:-changelog/db.changelog-master.yaml}"

echo "================================================================="
echo " [Luminia Database] TEST INTEGRAL DE MIGRACIÓN Y ROLLBACK"
echo " (Ejecutará UP -> DOWN -> UP para comprobar simetría de scripts)"
echo " Base de Datos : ${DB_HOST}:${DB_PORT}/${DB_NAME}"
echo "================================================================="

if command -v liquibase >/dev/null 2>&1; then
    liquibase \
        --url="jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}" \
        --username="${DB_USER}" \
        --password="${DB_PASSWORD}" \
        --changelog-file="${CHANGELOG_FILE}" \
        update-testing-rollback
elif command -v docker >/dev/null 2>&1; then
    echo "Ejecutando update-testing-rollback mediante Docker..."
    docker run --rm \
        --network="host" \
        -v "${DIR}/changelog:/liquibase/changelog" \
        -v "${DIR}/config:/liquibase/config" \
        liquibase/liquibase:4.27-alpine \
        --url="jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}" \
        --username="${DB_USER}" \
        --password="${DB_PASSWORD}" \
        --changelog-file="/liquibase/changelog/db.changelog-master.yaml" \
        update-testing-rollback
else
    echo "ERROR: Se requiere 'liquibase' CLI instalado o 'docker'."
    exit 1
fi

echo " Validado con éxito: Todos los changesets se aplican y revierten limpiamente."
