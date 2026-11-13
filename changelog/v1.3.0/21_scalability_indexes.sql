-- liquibase formatted sql

-- changeset luminia:v1.3.0-21-drop-redundant-indexes
-- comment: Drop redundant indexes covered by UNIQUE constraints or prefix-matching composite indexes
DROP INDEX IF EXISTS idx_admin_users_email;
DROP INDEX IF EXISTS idx_admin_users_firebase_uid;
DROP INDEX IF EXISTS idx_daily_sparks_date_tier;
DROP INDEX IF EXISTS idx_daily_sparks_active_date;
DROP INDEX IF EXISTS idx_user_career_simulations_lookup;
--rollback empty

-- changeset luminia:v1.3.0-21-pg-trgm-extension
-- comment: Enable pg_trgm extension for fast trigram ILIKE search on user_profiles
CREATE EXTENSION IF NOT EXISTS pg_trgm;
--rollback empty

-- changeset luminia:v1.3.0-21-idx-user-profiles-created-at runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_profiles_created_at
    ON user_profiles (created_at DESC);
--rollback DROP INDEX IF EXISTS idx_user_profiles_created_at;

-- changeset luminia:v1.3.0-21-idx-user-profiles-name-trgm runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_profiles_name_trgm
    ON user_profiles USING GIN (LOWER(name) gin_trgm_ops);
--rollback DROP INDEX IF EXISTS idx_user_profiles_name_trgm;

-- changeset luminia:v1.3.0-21-idx-user-profiles-email-trgm runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_profiles_email_trgm
    ON user_profiles USING GIN (LOWER(email) gin_trgm_ops);
--rollback DROP INDEX IF EXISTS idx_user_profiles_email_trgm;

-- changeset luminia:v1.3.0-21-idx-user-profiles-role-created runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_profiles_role_created
    ON user_profiles (role, created_at DESC);
--rollback DROP INDEX IF EXISTS idx_user_profiles_role_created;

-- changeset luminia:v1.3.0-21-idx-user-profiles-active-students runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_profiles_active_students
    ON user_profiles (created_at DESC)
    WHERE role = 'STUDENT' AND registration_status = 'ACTIVE';
--rollback DROP INDEX IF EXISTS idx_user_profiles_active_students;

-- changeset luminia:v1.3.0-21-user-profiles-role-check splitStatements:false
-- comment: Normalize role values and enforce valid UserRole values via CHECK constraint
UPDATE user_profiles SET role = UPPER(TRIM(role)) WHERE role <> UPPER(TRIM(role));

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'chk_user_profiles_role'
    ) THEN
        ALTER TABLE user_profiles
            ADD CONSTRAINT chk_user_profiles_role
            CHECK (role IN ('STUDENT', 'PARENT', 'GUARDIAN', 'TEACHER'))
            NOT VALID;
    END IF;
END $$;

ALTER TABLE user_profiles VALIDATE CONSTRAINT chk_user_profiles_role;
--rollback ALTER TABLE user_profiles DROP CONSTRAINT IF EXISTS chk_user_profiles_role;

-- changeset luminia:v1.3.0-21-idx-careers-lower-name runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_careers_lower_name
    ON careers (LOWER(name));
--rollback DROP INDEX IF EXISTS idx_careers_lower_name;

-- changeset luminia:v1.3.0-21-idx-admin-users-lower-email runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_admin_users_lower_email
    ON admin_users (LOWER(email));
--rollback DROP INDEX IF EXISTS idx_admin_users_lower_email;

-- changeset luminia:v1.3.0-21-idx-swipe-history-card-action runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_swipe_history_card_action
    ON user_swipe_history (card_id, action);
--rollback DROP INDEX IF EXISTS idx_user_swipe_history_card_action;

-- changeset luminia:v1.3.0-21-idx-swipe-history-user-action runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_swipe_history_user_action
    ON user_swipe_history (user_id, action, created_at DESC);
--rollback DROP INDEX IF EXISTS idx_user_swipe_history_user_action;

-- changeset luminia:v1.3.0-21-idx-spark-responses-user-spark runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_daily_spark_responses_user_spark
    ON daily_spark_responses (user_id, spark_id);
--rollback DROP INDEX IF EXISTS idx_daily_spark_responses_user_spark;

-- changeset luminia:v1.3.0-21-idx-mentorship-sessions-user-created runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mentorship_sessions_user_created
    ON mentorship_sessions (user_id, created_at DESC);
--rollback DROP INDEX IF EXISTS idx_mentorship_sessions_user_created;

-- changeset luminia:v1.3.0-21-idx-mentorship-sessions-active runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mentorship_sessions_active
    ON mentorship_sessions (user_id, career_id)
    WHERE status = 'IN_PROGRESS';
--rollback DROP INDEX IF EXISTS idx_mentorship_sessions_active;

-- changeset luminia:v1.3.0-21-idx-simulations-user-date runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_simulations_user_date
    ON user_career_simulations (user_id, created_at DESC);
--rollback DROP INDEX IF EXISTS idx_simulations_user_date;

-- changeset luminia:v1.3.0-21-idx-pathways-inst-id runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_pathways_inst_id
    ON educational_pathways (institution_id, id ASC);
--rollback DROP INDEX IF EXISTS idx_pathways_inst_id;

-- changeset luminia:v1.3.0-21-idx-institutions-country-tier runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_institutions_country_tier
    ON institutions (country_id, tier_level DESC, id);
--rollback DROP INDEX IF EXISTS idx_institutions_country_tier;

-- changeset luminia:v1.3.0-21-idx-outbox-delivered-cleanup runInTransaction:false
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_outbox_events_delivered_cleanup
    ON outbox_events (delivered_at)
    WHERE status = 'DELIVERED';
--rollback DROP INDEX IF EXISTS idx_outbox_events_delivered_cleanup;
