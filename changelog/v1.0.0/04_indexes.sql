--liquibase formatted sql

--changeset luminia-architect:04-indexes runInTransaction:true
--comment: Creación de índices optimizados espaciales (GIST), vectoriales (HNSW) y relacionales

CREATE INDEX IF NOT EXISTS idx_family_relationships_parent_id ON family_relationships(parent_id);
CREATE INDEX IF NOT EXISTS idx_family_relationships_student_id ON family_relationships(student_id);
CREATE INDEX IF NOT EXISTS idx_chat_sessions_user_id ON chat_sessions(user_id);

CREATE INDEX IF NOT EXISTS idx_institutions_country_id ON institutions(country_id);
CREATE INDEX IF NOT EXISTS idx_campuses_institution_id ON campuses(institution_id);
CREATE INDEX IF NOT EXISTS idx_campuses_location ON campuses USING GIST (location);

CREATE INDEX IF NOT EXISTS idx_careers_embedding_hnsw ON careers USING hnsw(embedding vector_cosine_ops);

CREATE INDEX IF NOT EXISTS idx_pathways_career_id ON educational_pathways(career_id);
CREATE INDEX IF NOT EXISTS idx_pathways_institution_id ON educational_pathways(institution_id);
CREATE INDEX IF NOT EXISTS idx_pathways_campus_id ON educational_pathways(campus_id);

--rollback DROP INDEX IF EXISTS idx_pathways_campus_id;
--rollback DROP INDEX IF EXISTS idx_pathways_institution_id;
--rollback DROP INDEX IF EXISTS idx_pathways_career_id;
--rollback DROP INDEX IF EXISTS idx_careers_embedding_hnsw;
--rollback DROP INDEX IF EXISTS idx_campuses_location;
--rollback DROP INDEX IF EXISTS idx_campuses_institution_id;
--rollback DROP INDEX IF EXISTS idx_institutions_country_id;
--rollback DROP INDEX IF EXISTS idx_chat_sessions_user_id;
--rollback DROP INDEX IF EXISTS idx_family_relationships_student_id;
--rollback DROP INDEX IF EXISTS idx_family_relationships_parent_id;
