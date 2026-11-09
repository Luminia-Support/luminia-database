--liquibase formatted sql

--changeset luminia-architect:14-drop-messages-json runInTransaction:true
--comment: Eliminacion de persistencia de chat (messages_json) en mentorship_sessions y user_career_simulations

-- 1. Eliminar indices de purga
DROP INDEX IF EXISTS idx_mentorship_sessions_purge;
DROP INDEX IF EXISTS idx_user_career_simulations_purge;

-- 2. Eliminar columnas messages_json
ALTER TABLE mentorship_sessions DROP COLUMN IF EXISTS messages_json;
ALTER TABLE user_career_simulations DROP COLUMN IF EXISTS messages_json;

--rollback ALTER TABLE mentorship_sessions ADD COLUMN IF NOT EXISTS messages_json JSONB DEFAULT NULL;
--rollback ALTER TABLE user_career_simulations ADD COLUMN IF NOT EXISTS messages_json JSONB DEFAULT NULL;
--rollback CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_purge ON mentorship_sessions(completed_at) WHERE status = 'COMPLETED' AND messages_json IS NOT NULL;
--rollback CREATE INDEX IF NOT EXISTS idx_user_career_simulations_purge ON user_career_simulations(completed_at) WHERE status = 'COMPLETED' AND messages_json IS NOT NULL;

