--liquibase formatted sql

--changeset luminia-architect:23-vocational-feedback-snooze-and-xp50 runInTransaction:true
--comment: Agrega soporte de Snooze (24h en el primer cierre y DISMISSED definitivo en el segundo) y ajusta recompensa a 50 XP

ALTER TABLE vocational_test_feedback
    ADD COLUMN IF NOT EXISTS dismiss_count INTEGER NOT NULL DEFAULT 0;

ALTER TABLE vocational_test_feedback
    ADD COLUMN IF NOT EXISTS snoozed_until TIMESTAMP;

ALTER TABLE vocational_test_feedback
    DROP CONSTRAINT IF EXISTS chk_vtf_status;

ALTER TABLE vocational_test_feedback
    ADD CONSTRAINT chk_vtf_status CHECK (status IN ('SUBMITTED', 'SNOOZED', 'DISMISSED'));

ALTER TABLE vocational_test_feedback
    DROP CONSTRAINT IF EXISTS chk_vtf_dismiss_count;

ALTER TABLE vocational_test_feedback
    ADD CONSTRAINT chk_vtf_dismiss_count CHECK (dismiss_count >= 0);

ALTER TABLE vocational_test_feedback
    DROP CONSTRAINT IF EXISTS chk_vtf_xp_awarded;

ALTER TABLE vocational_test_feedback
    ADD CONSTRAINT chk_vtf_xp_awarded CHECK (xp_awarded IN (0, 50));

--rollback ALTER TABLE vocational_test_feedback DROP CONSTRAINT IF EXISTS chk_vtf_xp_awarded;
--rollback ALTER TABLE vocational_test_feedback ADD CONSTRAINT chk_vtf_xp_awarded CHECK (xp_awarded IN (0, 25));
--rollback ALTER TABLE vocational_test_feedback DROP CONSTRAINT IF EXISTS chk_vtf_dismiss_count;
--rollback ALTER TABLE vocational_test_feedback DROP CONSTRAINT IF EXISTS chk_vtf_status;
--rollback ALTER TABLE vocational_test_feedback ADD CONSTRAINT chk_vtf_status CHECK (status IN ('SUBMITTED', 'DISMISSED'));
--rollback ALTER TABLE vocational_test_feedback DROP COLUMN IF EXISTS snoozed_until;
--rollback ALTER TABLE vocational_test_feedback DROP COLUMN IF EXISTS dismiss_count;
