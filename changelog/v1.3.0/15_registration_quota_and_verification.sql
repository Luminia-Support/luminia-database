--liquibase formatted sql

--changeset luminia-architect:15-registration-quota-and-verification runInTransaction:true
--comment: Control transaccional de cupos de registro (Beta 200), auto-reconciliacion y estado de activacion/waitlist en user_profiles

ALTER TABLE user_profiles
    ADD COLUMN IF NOT EXISTS registration_status VARCHAR(30) NOT NULL DEFAULT 'PENDING_PROFILE',
    ADD COLUMN IF NOT EXISTS email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS quota_claimed_at TIMESTAMP NULL,
    ADD COLUMN IF NOT EXISTS waitlisted_at TIMESTAMP NULL;

-- Marcar perfiles ya completados previamente como ACTIVE con cupo reclamado
UPDATE user_profiles
SET registration_status = 'ACTIVE',
    email_verified = TRUE,
    quota_claimed_at = created_at
WHERE name IS NOT NULL
  AND birth_date IS NOT NULL
  AND gender IS NOT NULL
  AND country IS NOT NULL
  AND latitude IS NOT NULL
  AND longitude IS NOT NULL;

CREATE TABLE IF NOT EXISTS platform_registration_config (
    id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
    quota_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    max_allowed_users INT NOT NULL DEFAULT 200 CHECK (max_allowed_users >= 0),
    current_registered_count INT NOT NULL DEFAULT 0 CHECK (current_registered_count >= 0),
    updated_by VARCHAR(128),
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO platform_registration_config (id, quota_enabled, max_allowed_users, current_registered_count)
VALUES (
    1,
    TRUE,
    200,
    (SELECT COUNT(*) FROM user_profiles WHERE registration_status = 'ACTIVE' AND role = 'STUDENT')
)
ON CONFLICT (id) DO NOTHING;

CREATE INDEX IF NOT EXISTS idx_user_profiles_reg_status ON user_profiles (registration_status, waitlisted_at);

--rollback DROP INDEX IF EXISTS idx_user_profiles_reg_status;
--rollback DROP TABLE IF EXISTS platform_registration_config;
--rollback ALTER TABLE user_profiles DROP COLUMN IF EXISTS waitlisted_at, DROP COLUMN IF EXISTS quota_claimed_at, DROP COLUMN IF EXISTS email_verified, DROP COLUMN IF EXISTS registration_status;

