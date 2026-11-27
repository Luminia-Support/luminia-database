--liquibase formatted sql

--changeset luminia-architect:27-drop-redundant-vtf-status-created runInTransaction:true
--comment: Elimina el indice obsoleto (status, created_at DESC) reemplazado por indices sobre updated_at
DROP INDEX IF EXISTS idx_vocational_test_feedback_status_created;
--rollback CREATE INDEX IF NOT EXISTS idx_vocational_test_feedback_status_created ON vocational_test_feedback(status, created_at DESC);

--changeset luminia-architect:27-idx-vtf-updated-at-desc runInTransaction:false
--comment: Indice B-Tree ligero para filtros de rango temporal y ordenamiento por updated_at en la vista admin de encuestas
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_vtf_updated_at_desc
    ON vocational_test_feedback (updated_at DESC);
--rollback DROP INDEX IF EXISTS idx_vtf_updated_at_desc;

--changeset luminia-architect:27-idx-vtf-status-updated-at runInTransaction:false
--comment: Indice B-Tree compuesto para filtrar por estado y rango temporal en vocational_test_feedback
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_vtf_status_updated_at
    ON vocational_test_feedback (status, updated_at DESC);
--rollback DROP INDEX IF EXISTS idx_vtf_status_updated_at;

--changeset luminia-architect:27-idx-vocational-profiles-eligible-baseline runInTransaction:false
--comment: Indice B-Tree parcial para Index-Only Scan de usuarios elegibles en vocational_profiles preservando HOT updates
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_vocational_profiles_eligible_baseline
    ON vocational_profiles (baseline_completed_at DESC)
    WHERE completion_percentage >= 100 OR baseline_completed_at IS NOT NULL;
--rollback DROP INDEX IF EXISTS idx_vocational_profiles_eligible_baseline;
