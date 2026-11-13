--liquibase formatted sql

--changeset luminia-architect:20-outbox-processing-columns runInTransaction:true
--comment: Agrega columnas locked_at y next_attempt_at en outbox_events (ms-main) para reclamo seguro con FOR UPDATE SKIP LOCKED y backoff exponencial
ALTER TABLE outbox_events
    ADD COLUMN IF NOT EXISTS locked_at TIMESTAMP(6) NULL,
    ADD COLUMN IF NOT EXISTS next_attempt_at TIMESTAMP(6) NULL;

--rollback ALTER TABLE outbox_events DROP COLUMN IF EXISTS next_attempt_at, DROP COLUMN IF EXISTS locked_at;

--changeset luminia-architect:20-user-profile-outbox runInTransaction:true
--comment: Tabla transaccional user_profile_outbox_events en ms-user-profile para sincronizacion garantizada (at-least-once) de Custom Claims en Firebase
CREATE TABLE IF NOT EXISTS user_profile_outbox_events (
    id BIGSERIAL PRIMARY KEY,
    aggregate_id VARCHAR(128) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    payload JSONB NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    attempts INTEGER NOT NULL DEFAULT 0,
    last_error TEXT,
    next_attempt_at TIMESTAMP(6),
    locked_at TIMESTAMP(6),
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivered_at TIMESTAMP(6)
);

CREATE INDEX IF NOT EXISTS idx_up_outbox_pending
    ON user_profile_outbox_events (next_attempt_at NULLS FIRST, created_at ASC)
    WHERE status = 'PENDING';

CREATE INDEX IF NOT EXISTS idx_up_outbox_aggregate
    ON user_profile_outbox_events (aggregate_id)
    WHERE status = 'PENDING';

CREATE INDEX IF NOT EXISTS idx_up_outbox_cleanup
    ON user_profile_outbox_events (delivered_at)
    WHERE status IN ('DELIVERED', 'SUPERSEDED');

--rollback DROP INDEX IF EXISTS idx_up_outbox_cleanup;
--rollback DROP INDEX IF EXISTS idx_up_outbox_aggregate;
--rollback DROP INDEX IF EXISTS idx_up_outbox_pending;
--rollback DROP TABLE IF EXISTS user_profile_outbox_events;

--changeset luminia-architect:20-reconcile-registration-counter runInTransaction:true
--comment: Reconcilia current_registered_count en platform_registration_config antes de usar incremento atomico condicional
UPDATE platform_registration_config
SET current_registered_count = (
    SELECT COUNT(*)
    FROM user_profiles
    WHERE registration_status = 'ACTIVE' AND role = 'STUDENT'
)
WHERE id = 1;

--rollback SELECT 1;

