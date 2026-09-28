--liquibase formatted sql

--changeset luminia-architect:13-drop-mentorship-sessions-riasec-impact runInTransaction:true
--comment: Drop riasec_impact from mentorship_sessions table

ALTER TABLE mentorship_sessions DROP COLUMN IF EXISTS riasec_impact;

--rollback ALTER TABLE mentorship_sessions ADD COLUMN IF NOT EXISTS riasec_impact JSONB DEFAULT NULL;
