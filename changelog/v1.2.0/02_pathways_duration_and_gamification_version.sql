--liquibase formatted sql

--changeset luminia-architect:02-pathways-duration-and-gamification-version runInTransaction:true
--comment: Columna numérica duration_years indexada y versionamiento para control de concurrencia optimista

-- 1. Agregar columna estructurada duration_years
ALTER TABLE educational_pathways ADD COLUMN IF NOT EXISTS duration_years NUMERIC(3,1);

-- 2. Poblar duration_years de forma segura desde duration existente
UPDATE educational_pathways 
SET duration_years = NULLIF(REGEXP_REPLACE(SPLIT_PART(duration, ' ', 1), '[^0-9.]', '', 'g'), '')::NUMERIC 
WHERE duration IS NOT NULL AND duration_years IS NULL;

-- 3. Crear índice para el filtrado rápido de duración máxima
CREATE INDEX IF NOT EXISTS idx_pathways_duration_years ON educational_pathways(duration_years);

-- 4. Columna de versionamiento para concurrencia optimista en gamificación
ALTER TABLE user_gamification ADD COLUMN IF NOT EXISTS version BIGINT NOT NULL DEFAULT 0;

--rollback ALTER TABLE user_gamification DROP COLUMN IF EXISTS version;
--rollback DROP INDEX IF EXISTS idx_pathways_duration_years;
--rollback ALTER TABLE educational_pathways DROP COLUMN IF EXISTS duration_years;
