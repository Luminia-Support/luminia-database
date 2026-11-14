--liquibase formatted sql

--changeset luminia-architect:22-vocational-test-feedback runInTransaction:true
--comment: Tabla de feedback post-test vocacional evaluando proceso conversacional, resumen de análisis, indicadores RIASEC+EQ y carreras sugeridas

CREATE TABLE IF NOT EXISTS vocational_test_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES user_profiles(id) ON DELETE CASCADE,
    process_rating SMALLINT,
    analysis_rating SMALLINT,
    psychometrics_rating SMALLINT,
    careers_rating SMALLINT,
    comment TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'SUBMITTED',
    xp_awarded INTEGER NOT NULL DEFAULT 0,
    interaction_count_snapshot INTEGER,
    baseline_completed_at_snapshot TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_vtf_process_rating CHECK (process_rating IS NULL OR (process_rating BETWEEN 1 AND 5)),
    CONSTRAINT chk_vtf_analysis_rating CHECK (analysis_rating IS NULL OR (analysis_rating BETWEEN 1 AND 5)),
    CONSTRAINT chk_vtf_psychometrics_rating CHECK (psychometrics_rating IS NULL OR (psychometrics_rating BETWEEN 1 AND 5)),
    CONSTRAINT chk_vtf_careers_rating CHECK (careers_rating IS NULL OR (careers_rating BETWEEN 1 AND 5)),
    CONSTRAINT chk_vtf_comment_length CHECK (comment IS NULL OR char_length(comment) <= 500),
    CONSTRAINT chk_vtf_xp_awarded CHECK (xp_awarded IN (0, 25)),
    CONSTRAINT chk_vtf_status CHECK (status IN ('SUBMITTED', 'DISMISSED'))
);

CREATE INDEX IF NOT EXISTS idx_vocational_test_feedback_status_created
    ON vocational_test_feedback(status, created_at DESC);

--rollback DROP INDEX IF EXISTS idx_vocational_test_feedback_status_created;
--rollback DROP TABLE IF EXISTS vocational_test_feedback CASCADE;