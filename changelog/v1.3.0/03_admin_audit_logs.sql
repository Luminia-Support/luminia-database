--liquibase formatted sql

--changeset luminia-architect:03-admin-audit-logs runInTransaction:true
--comment: Tabla inmutable de auditoría para operaciones e intervenciones administrativas

CREATE TABLE IF NOT EXISTS admin_audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_uid VARCHAR(128) NOT NULL,
    admin_email VARCHAR(255) NOT NULL,
    target_user_id UUID,
    action_type VARCHAR(50) NOT NULL,
    details_json JSONB,
    reason TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_admin_audit_logs_target ON admin_audit_logs(target_user_id);
CREATE INDEX IF NOT EXISTS idx_admin_audit_logs_action ON admin_audit_logs(action_type);
CREATE INDEX IF NOT EXISTS idx_admin_audit_logs_created ON admin_audit_logs(created_at DESC);

--rollback DROP TABLE IF EXISTS admin_audit_logs;
