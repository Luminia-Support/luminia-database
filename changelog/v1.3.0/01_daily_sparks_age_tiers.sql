--liquibase formatted sql

--changeset luminia-architect:01-daily-sparks-age-tiers runInTransaction:true
--comment: Agrega columna age_tier (SMALLINT) y restricción de unicidad compuesta (active_date, age_tier) para segmentación por cohortes etarias

-- 1. Agregar columna age_tier con valor por defecto 2 (SENIOR) para backfill transparente
ALTER TABLE daily_sparks 
    ADD COLUMN IF NOT EXISTS age_tier SMALLINT NOT NULL DEFAULT 2;

-- 2. Eliminar la restricción de unicidad anterior de fecha sola
ALTER TABLE daily_sparks 
    DROP CONSTRAINT IF EXISTS daily_sparks_active_date_key;

-- 3. Crear restricción de unicidad compuesta por fecha y nivel etario
ALTER TABLE daily_sparks 
    ADD CONSTRAINT uq_daily_sparks_date_tier UNIQUE (active_date, age_tier);

-- 4. Restricción de verificación para valores permitidos (1=JUNIOR, 2=SENIOR)
ALTER TABLE daily_sparks 
    ADD CONSTRAINT chk_daily_sparks_age_tier CHECK (age_tier IN (1, 2));

-- 5. Índice compuesto para acelerar búsquedas por fecha y nivel etario
CREATE INDEX IF NOT EXISTS idx_daily_sparks_date_tier 
    ON daily_sparks(active_date, age_tier);

COMMENT ON COLUMN daily_sparks.age_tier IS 'Nivel etario: 1 = JUNIOR (13-15 años), 2 = SENIOR (16+ años). Preparado para 3 = VISION en el futuro.';

--rollback DROP INDEX IF EXISTS idx_daily_sparks_date_tier;
--rollback ALTER TABLE daily_sparks DROP CONSTRAINT IF EXISTS chk_daily_sparks_age_tier;
--rollback ALTER TABLE daily_sparks DROP CONSTRAINT IF EXISTS uq_daily_sparks_date_tier;
--rollback ALTER TABLE daily_sparks DROP COLUMN IF EXISTS age_tier;
--rollback ALTER TABLE daily_sparks ADD CONSTRAINT daily_sparks_active_date_key UNIQUE (active_date);
