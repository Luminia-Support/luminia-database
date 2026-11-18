--liquibase formatted sql

--changeset luminia-architect:v1.3.0-24-quest-scenario-context runInTransaction:true
--comment: Contexto de reto (mission_title, scenario_summary) y metadatos de deduplicacion Nivel 1 (scenario_metadata) en user_career_simulations

ALTER TABLE user_career_simulations
    ADD COLUMN IF NOT EXISTS mission_title VARCHAR(150) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS scenario_summary TEXT DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS scenario_metadata JSONB DEFAULT NULL;

CREATE INDEX IF NOT EXISTS idx_simulations_user_career_recent
    ON user_career_simulations (user_id, associated_career_id, created_at DESC)
    WHERE status = 'COMPLETED' AND scenario_metadata IS NOT NULL;

--rollback DROP INDEX IF EXISTS idx_simulations_user_career_recent;
--rollback ALTER TABLE user_career_simulations DROP COLUMN IF EXISTS scenario_metadata;
--rollback ALTER TABLE user_career_simulations DROP COLUMN IF EXISTS scenario_summary;
--rollback ALTER TABLE user_career_simulations DROP COLUMN IF EXISTS mission_title;
