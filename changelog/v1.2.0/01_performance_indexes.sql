--liquibase formatted sql

--changeset luminia-architect:01-performance-indexes runInTransaction:true
--comment: Habilitar extensión pg_trgm, índices GIN trigram, índices compuestos y unicidad relacional

-- 1. Extensión para búsquedas difusas y optimización de ILIKE
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 2. Índices GIN trigram para búsquedas de texto parcial ultrarrápidas
CREATE INDEX IF NOT EXISTS idx_careers_name_trgm ON careers USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_institutions_name_trgm ON institutions USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_pathways_program_name_trgm ON educational_pathways USING gin (program_name gin_trgm_ops);

-- 3. Índice compuesto para historial cronológico de sesiones de chat (evita sort en memoria)
CREATE INDEX IF NOT EXISTS idx_chat_sessions_user_date ON chat_sessions(user_id, session_date DESC);

-- 4. Índice compuesto para verificación directa de simulaciones completadas
CREATE INDEX IF NOT EXISTS idx_user_career_simulations_lookup ON user_career_simulations(user_id, associated_career_id);

-- 5. Restricción de unicidad para evitar relaciones familiares duplicadas
ALTER TABLE family_relationships ADD CONSTRAINT uq_parent_student UNIQUE (parent_id, student_id);

--rollback ALTER TABLE family_relationships DROP CONSTRAINT IF EXISTS uq_parent_student;
--rollback DROP INDEX IF EXISTS idx_user_career_simulations_lookup;
--rollback DROP INDEX IF EXISTS idx_chat_sessions_user_date;
--rollback DROP INDEX IF EXISTS idx_pathways_program_name_trgm;
--rollback DROP INDEX IF EXISTS idx_institutions_name_trgm;
--rollback DROP INDEX IF EXISTS idx_careers_name_trgm;
