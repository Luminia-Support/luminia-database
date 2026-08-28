--liquibase formatted sql

--changeset luminia-architect:02-user-profiles-schema runInTransaction:true
--comment: Creación de tablas de usuarios, relaciones familiares, perfiles vocacionales y sesiones de chat

CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    firebase_uid VARCHAR(128) UNIQUE NOT NULL,
    name VARCHAR(150),
    email VARCHAR(255) UNIQUE,
    role VARCHAR(50) NOT NULL,
    birth_date DATE,
    gender VARCHAR(50),
    country VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    consent_granted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS family_relationships (
    id BIGSERIAL PRIMARY KEY,
    parent_id UUID NOT NULL,
    student_id UUID NOT NULL,
    relationship_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_family_student FOREIGN KEY (student_id) REFERENCES user_profiles(id),
    CONSTRAINT fk_family_parent FOREIGN KEY (parent_id) REFERENCES user_profiles(id)
);

CREATE TABLE IF NOT EXISTS vocational_profiles (
    user_id UUID PRIMARY KEY REFERENCES user_profiles(id),
    completion_percentage INT DEFAULT 0,
    riasec_scores JSONB DEFAULT '{}',
    eq_scores JSONB DEFAULT '{}',
    interview_phase VARCHAR(50) DEFAULT 'rapport',
    interaction_count INT DEFAULT 0,
    last_profiled_message TEXT,
    identified_traits TEXT[] DEFAULT '{}',
    top_careers TEXT[] DEFAULT '{}',
    selected_career_ids INTEGER[] DEFAULT '{}',
    analysis_summary TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS chat_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(id),
    session_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    summary TEXT NOT NULL
);

--rollback DROP TABLE IF EXISTS chat_sessions CASCADE;
--rollback DROP TABLE IF EXISTS vocational_profiles CASCADE;
--rollback DROP TABLE IF EXISTS family_relationships CASCADE;
--rollback DROP TABLE IF EXISTS user_profiles CASCADE;
