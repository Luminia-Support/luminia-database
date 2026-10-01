--liquibase formatted sql

--changeset luminia-architect:07-outbox-events runInTransaction:true
--comment: Tabla transaccional outbox_events para sincronizacion resiliente de eventos y patron transactional outbox

CREATE TABLE IF NOT EXISTS outbox_events (
    id UUID PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    aggregate_type VARCHAR(100) NOT NULL,
    aggregate_id VARCHAR(100) NOT NULL,
    idempotency_key VARCHAR(100) NOT NULL,
    payload_json JSONB NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    retry_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivered_at TIMESTAMP(6),
    last_error TEXT,
    CONSTRAINT uk_outbox_events_idempotency UNIQUE (idempotency_key)
);

CREATE INDEX IF NOT EXISTS idx_outbox_events_pending ON outbox_events (created_at ASC) WHERE status = 'PENDING';

--rollback DROP TABLE IF EXISTS outbox_events CASCADE;
