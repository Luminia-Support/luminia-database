# Luminia Database - Gobernanza y Migraciones de Base de Datos

Módulo centralizado y desacoplado para la gestión del ciclo de vida, esquema DDL, cargas maestras y reversiones (*rollback*) de la base de datos PostgreSQL de **Luminia**.

---

## 🚀 Arquitectura y Tecnologías

* **Motor**: PostgreSQL 16 con extensiones `uuid-ossp`, `postgis` y `pgvector` (Azure Flexible Server).
* **Herramienta de Migración**: [Liquibase Formatted SQL](https://docs.liquibase.com/concepts/changelogs/sql-format.html).
* **Estrategia de Rollback**: Simetría obligatoria (`--rollback`) en el 100% de los *changesets*.
* **Automatización CI/CD**: Workflows de GitHub Actions para validación en PRs y despliegue continuo con Rollback automático.

---

## 📁 Estructura del Proyecto

```text
luminia/
├── .github/workflows/
│   ├── db-pr-validation.yml             # CI: Validación y test de rollback en PRs
│   └── db-deploy.yml                    # CD: Despliegue y Rollback automático en Azure
├── luminia-database/
│   ├── changelog/
│   │   ├── db.changelog-master.yaml     # Orquestador maestro
│   │   ├── v1.0.0/                      # Migración inicial (import.sql)
│   │   │   ├── 01_extensions.sql        # postgis, vector, uuid-ossp
│   │   │   ├── 02_user_profiles_schema.sql  # user_profiles, family_relationships, vocational_profiles, chat_sessions
│   │   │   ├── 03_academic_catalog.sql  # countries, institution_types, institutions, campuses, careers, pathways
│   │   │   ├── 04_indexes.sql           # GIST (espacial), HNSW (vectorial), FKs
│   │   │   └── 05_seed_reference_data.sql # Semillas base (PE, Universidad, Instituto)
│   │   └── v1.1.0/                      # Gamificación, Retos Diarios y Simulaciones
│   │       ├── 01_gamification_schema.sql # user_gamification, daily_sparks, daily_spark_responses, user_career_simulations
│   │       └── 02_seed_daily_sparks.sql # Retos diarios generados por IA (60-90 días) con rotación semanal
│   ├── config/
│   │   ├── liquibase.properties.template # Plantilla de variables de conexión
│   │   └── liquibase.docker.properties
│   ├── scripts/
│   │   ├── migrate.sh                   # Aplica todos los cambios pendientes (update)
│   │   ├── rollback.sh                  # Revierte N cambios (rollback-count N)
│   │   ├── status.sh                    # Muestra estado de migraciones
│   │   └── test-rollback-local.sh       # Test completo: UP -> ROLLBACK -> UP
│   ├── Dockerfile                       # Imagen ligera para pipelines
│   └── README.md
```

---

## 🔐 Configuración de Secretos en GitHub (Repository Secrets)

Para que los workflows de CI/CD puedan autenticarse contra la base de datos de Azure (o cualquier entorno remoto), se deben configurar los siguientes **Repository Secrets** en GitHub:

1. Ve a tu repositorio en GitHub: **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret**.
2. Agrega los siguientes secretos:

| Nombre del Secreto | Descripción | Ejemplo / Valor |
| :--- | :--- | :--- |
| `DB_HOST` | Hostname del servidor Azure PostgreSQL Flexible Server | `psql-luminia-prod-xxxxx.postgres.database.azure.com` |
| `DB_PORT` | Puerto de conexión a PostgreSQL *(Opcional, por defecto `5432`)* | `5432` |
| `DB_NAME` | Nombre de la base de datos relacional | `luminia_db` |
| `DB_USER` | Usuario administrador de la base de datos | `dbadmin` |
| `DB_PASSWORD` | Contraseña del usuario administrador | `TuPasswordSeguro123!` |

---

## 🔄 Flujos Automatizados en GitHub Actions

### 1. Validación en Pull Requests (`db-pr-validation.yml`)
* **Disparador**: Al abrir o actualizar un PR que modifique archivos en `luminia-database/**`.
* **Proceso**:
  1. Levanta un contenedor de servicio efímero `pgvector/pgvector:pg16` dentro del runner de GitHub.
  2. Ejecuta `liquibase update-testing-rollback`.
  3. Aplica todos los changesets (`UP`), ejecuta todos los scripts de reversión (`ROLLBACK`), y vuelve a aplicar los cambios (`UP`).
* **Garantía**: Si algún script SQL tiene error de sintaxis o carece de script de rollback simétrico, el PR queda **bloqueado automáticamente**.

### 2. Despliegue Continuo con Rollback (`db-deploy.yml`)
* **Disparador**: 
  * `Push` a la rama `main` modificando `luminia-database/**`.
  * Manualmente mediante **`workflow_dispatch`** (pestaña *Actions* en GitHub).
* **Proceso**:
  1. Crea un **Checkpoint Tag** en Liquibase (`release-${{ github.sha }}`) antes de alterar la BD.
  2. Ejecuta `liquibase update`.
  3. **Auto-Rollback**: Si la migración falla, el step `Automated Rollback on Failure` revierte automáticamente los cambios hasta el checkpoint previo.

### 3. Reversión Manual desde GitHub Actions UI
1. Ve a la pestaña **Actions** en GitHub.
2. Selecciona el workflow **"Database CD - Deploy & Automated Rollback"**.
3. Haz clic en **Run workflow**.
4. En el selector *Acción de base de datos a ejecutar*, elige **`rollback-last`** y presiona **Run workflow**.

---

## 🛠️ Guía Rápida de Uso Local

### 1. Variables de Entorno
Configura las variables antes de ejecutar los scripts (o utiliza los valores por defecto):
```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=luminia_db
export DB_USER=postgres
export DB_PASSWORD=postgres
```

### 2. Aplicar Migraciones (`UPDATE`)
Aplica todos los cambios pendientes a la base de datos:
```bash
./scripts/migrate.sh
```

### 3. Revertir Cambios (`ROLLBACK`)
Para revertir el último changeset o un número específico:
```bash
# Revertir 1 changeset:
./scripts/rollback.sh 1

# Revertir los últimos 3 changesets:
./scripts/rollback.sh 3
```

### 4. Probar Simetría de Rollback (`TEST INTEGRAL`)
Valida que todos los scripts suban y bajen de forma limpia en tu entorno local:
```bash
./scripts/test-rollback-local.sh
```

---

## 📝 Reglas de Oro para Nuevas Migraciones

1. **Directiva `--rollback` Obligatoria**: Todo nuevo `--changeset` debe incluir obligatoriamente su sentencia de reversión correspondiente.
2. **Inmutabilidad**: Nunca editar un archivo de versión ya desplegado en producción (`v1.0.0/`). Los cambios se agregan en una nueva carpeta (ej. `changelog/migrations/v1.1.0/`).
3. **Idempotencia**: Usar `CREATE TABLE IF NOT EXISTS`, `ON CONFLICT DO UPDATE`, `DROP ... IF EXISTS`.
4. **Embeddings & Vectores**:
   * Las cargas masivas de datos maestros (`careers`) pueden incluir vectores pre-calculados (`'[-0.01, ...]'::vector(1536)`).
   * Nuevas carreras creadas por APIs o sin vector serán detectadas y sincronizadas automáticamente por `CareerVectorSyncJob` en `luminia-ms-main`.
