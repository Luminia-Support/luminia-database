--liquibase formatted sql

--changeset luminia-architect:26-traits-delta-idempotency runInTransaction:true
--comment: Tabla transaccional para garantizar idempotencia de applyTraitsDelta en PostgreSQL (respaldo ante caida o expiracion de Redis)
CREATE TABLE IF NOT EXISTS traits_delta_idempotency (
    idempotency_key VARCHAR(100) PRIMARY KEY,
    processed_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_traits_delta_idempotency_processed_at
    ON traits_delta_idempotency (processed_at);

--rollback DROP INDEX IF EXISTS idx_traits_delta_idempotency_processed_at;
--rollback DROP TABLE IF EXISTS traits_delta_idempotency;

--changeset luminia-architect:26-idx-outbox-events-processing-locked runInTransaction:false
--comment: Indice parcial para evitar Seq Scan en recoverStaleProcessing de outbox_events (ms-main)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_outbox_events_processing_locked
    ON outbox_events (locked_at)
    WHERE status = 'PROCESSING';

--rollback DROP INDEX IF EXISTS idx_outbox_events_processing_locked;

--changeset luminia-architect:26-idx-outbox-events-pending-next-attempt runInTransaction:false
--comment: Indice parcial optimizado para claimPendingBatch filtrando por next_attempt_at y created_at en outbox_events (ms-main)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_outbox_events_pending_next_attempt
    ON outbox_events (next_attempt_at NULLS FIRST, created_at ASC)
    WHERE status = 'PENDING';

--rollback DROP INDEX IF EXISTS idx_outbox_events_pending_next_attempt;

--changeset luminia-architect:26-idx-up-outbox-processing-locked runInTransaction:false
--comment: Indice parcial para evitar Seq Scan en recoverStaleProcessing de user_profile_outbox_events (ms-user-profile)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_up_outbox_processing_locked
    ON user_profile_outbox_events (locked_at)
    WHERE status = 'PROCESSING';

--rollback DROP INDEX IF EXISTS idx_up_outbox_processing_locked;
