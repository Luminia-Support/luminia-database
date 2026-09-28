--liquibase formatted sql

--changeset luminia-architect:12-user-career-simulations-lifecycle runInTransaction:true
--comment: Ciclo de vida (IN_PROGRESS/COMPLETED), persistencia de dialogo (messages_json) y reanudacion para misiones vocacionales

-- 1. Agregar columnas para ciclo de vida y persistencia de mensajes
ALTER TABLE user_career_simulations 
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'COMPLETED',
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN IF NOT EXISTS messages_json JSONB DEFAULT NULL;

-- 2. Permitir NULL en campos mientras la sesion este IN_PROGRESS
ALTER TABLE user_career_simulations 
    ALTER COLUMN completed_at DROP NOT NULL,
    ALTER COLUMN completed_at SET DEFAULT NULL,
    ALTER COLUMN decisions_summary DROP NOT NULL,
    ALTER COLUMN discovered_traits DROP NOT NULL;

-- 3. Constraint de integridad para estados permitidos
ALTER TABLE user_career_simulations
    ADD CONSTRAINT chk_user_career_simulations_status 
    CHECK (status IN ('IN_PROGRESS', 'COMPLETED', 'ABANDONED'));

-- 4. Indice compuesto para busqueda y reanudacion de sesiones activas
CREATE INDEX IF NOT EXISTS idx_user_career_simulations_active 
    ON user_career_simulations(user_id, associated_career_id, status);

-- 5. Indice parcial para optimizacion de consultas de historial y purga
CREATE INDEX IF NOT EXISTS idx_user_career_simulations_purge 
    ON user_career_simulations(completed_at) 
    WHERE status = 'COMPLETED' AND messages_json IS NOT NULL;

--rollback DROP INDEX IF EXISTS idx_user_career_simulations_purge;
--rollback DROP INDEX IF EXISTS idx_user_career_simulations_active;
--rollback ALTER TABLE user_career_simulations DROP CONSTRAINT IF EXISTS chk_user_career_simulations_status;
--rollback ALTER TABLE user_career_simulations DROP COLUMN IF EXISTS messages_json;
--rollback ALTER TABLE user_career_simulations DROP COLUMN IF EXISTS created_at;
--rollback ALTER TABLE user_career_simulations DROP COLUMN IF EXISTS status;
