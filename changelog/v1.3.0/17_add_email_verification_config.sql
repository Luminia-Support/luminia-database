--liquibase formatted sql

--changeset luminia-architect:17-add-email-verification-config runInTransaction:true
--comment: Agrega control dinamico email_verification_required en platform_registration_config

ALTER TABLE platform_registration_config
    ADD COLUMN IF NOT EXISTS email_verification_required BOOLEAN NOT NULL DEFAULT FALSE;

--rollback ALTER TABLE platform_registration_config DROP COLUMN IF EXISTS email_verification_required;

