--liquibase formatted sql

--changeset luminia-architect:18-mentorship-daily-limit-config runInTransaction:true
--comment: Agrega limite diario configurable de sesiones de mentoria sin consumo de llaves

ALTER TABLE platform_subscription_config
    ADD COLUMN IF NOT EXISTS max_daily_mentor_sessions INT NOT NULL DEFAULT 1
    CHECK (max_daily_mentor_sessions > 0);

--rollback ALTER TABLE platform_subscription_config DROP COLUMN IF EXISTS max_daily_mentor_sessions;

