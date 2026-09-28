--liquibase formatted sql

--changeset luminia-architect:06-mentorship-reverse-shadowing runInTransaction:true
--comment: Tablas y constraints para Reverse Shadowing con Mentor IA y retención híbrida de mensajes

-- 1. Arquetipos de mentores jóvenes asociados a carreras
CREATE TABLE IF NOT EXISTS career_mentor_archetypes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    career_id INTEGER NOT NULL REFERENCES careers(id) ON DELETE CASCADE,
    mentor_name VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(255),
    years_of_experience INT NOT NULL DEFAULT 3,
    specialty VARCHAR(150) NOT NULL,
    bio TEXT NOT NULL,
    system_prompt_overlay TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Sesiones de mentoría (Ficha Permanente de Takeaways)
CREATE TABLE IF NOT EXISTS mentorship_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    career_id INTEGER NOT NULL REFERENCES careers(id) ON DELETE CASCADE,
    archetype_id UUID REFERENCES career_mentor_archetypes(id) ON DELETE SET NULL,
    is_free_session BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS',
    question_count INT NOT NULL DEFAULT 0,
    takeaways_json JSONB DEFAULT NULL,
    riasec_impact JSONB DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP DEFAULT NULL,
    CONSTRAINT chk_mentorship_status CHECK (status IN ('IN_PROGRESS', 'COMPLETED', 'ABANDONED'))
);

-- 3. Mensajes crudos de chat (Retención temporal - TTL 30 días)
CREATE TABLE IF NOT EXISTS mentorship_chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES mentorship_sessions(id) ON DELETE CASCADE,
    sender_type VARCHAR(10) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_mentorship_sender CHECK (sender_type IN ('STUDENT', 'MENTOR', 'SYSTEM'))
);

-- 4. Índices para rendimiento y purga
CREATE INDEX IF NOT EXISTS idx_career_mentor_career ON career_mentor_archetypes(career_id, is_active);
CREATE INDEX IF NOT EXISTS idx_mentorship_sessions_user ON mentorship_sessions(user_id, status);
CREATE INDEX IF NOT EXISTS idx_mentorship_messages_session ON mentorship_chat_messages(session_id, created_at);
CREATE INDEX IF NOT EXISTS idx_mentorship_messages_created_at ON mentorship_chat_messages(created_at);

--rollback DROP TABLE IF EXISTS mentorship_chat_messages CASCADE;
--rollback DROP TABLE IF EXISTS mentorship_sessions CASCADE;
--rollback DROP TABLE IF EXISTS career_mentor_archetypes CASCADE;
