--liquibase formatted sql

--changeset luminia-architect:09-mentorship-jsonb-simplification runInTransaction:true
--comment: Simplificacion de persistencia de chat de mentoria usando JSONB y eliminacion de tabla transaccional

-- 1. Agregar columna messages_json en mentorship_sessions para guardar el historial consolidado de chat
ALTER TABLE mentorship_sessions ADD COLUMN IF NOT EXISTS messages_json JSONB DEFAULT NULL;

-- 2. Eliminar la tabla transaccional secundaria de mensajes de chat
DROP TABLE IF EXISTS mentorship_chat_messages CASCADE;

-- 3. Crear indice parcial para optimizar la purga a los 30 dias de sesiones completadas con mensajes
CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_purge ON mentorship_sessions(completed_at) WHERE status = 'COMPLETED' AND messages_json IS NOT NULL;

--rollback DROP INDEX IF EXISTS idx_mentorship_sessions_purge;
--rollback ALTER TABLE mentorship_sessions DROP COLUMN IF EXISTS messages_json;
--rollback CREATE TABLE IF NOT EXISTS mentorship_chat_messages (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), session_id UUID NOT NULL REFERENCES mentorship_sessions(id) ON DELETE CASCADE, sender_type VARCHAR(10) NOT NULL, content TEXT NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT chk_mentorship_sender CHECK (sender_type IN ('STUDENT', 'MENTOR', 'SYSTEM')));
--rollback CREATE INDEX IF NOT EXISTS idx_mentorship_messages_session ON mentorship_chat_messages(session_id, created_at);
--rollback CREATE INDEX IF NOT EXISTS idx_mentorship_messages_created_at ON mentorship_chat_messages(created_at);
