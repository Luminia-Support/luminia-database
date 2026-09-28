--liquibase formatted sql

--changeset luminia-architect:03-user-selected-careers runInTransaction:true
--comment: Tabla relacional user_selected_careers con constraints de ciberseguridad y migración de datos

-- 1. Creación de la tabla relacional intermedia
CREATE TABLE IF NOT EXISTS user_selected_careers (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    career_id INTEGER NOT NULL REFERENCES careers(id) ON DELETE CASCADE,
    preference_order INT NOT NULL DEFAULT 1,
    source VARCHAR(30) NOT NULL DEFAULT 'TEST_AI',
    selected_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_user_career UNIQUE (user_id, career_id),
    CONSTRAINT chk_career_source CHECK (source IN ('TEST_AI', 'EXPLORE_MANUAL', 'CAREER_QUEST', 'SPARK_CHALLENGE'))
);

-- 2. Índices de consulta bidireccional
CREATE INDEX IF NOT EXISTS idx_user_selected_careers_user ON user_selected_careers(user_id, preference_order);
CREATE INDEX IF NOT EXISTS idx_user_selected_careers_career ON user_selected_careers(career_id);

-- 3. Migración atómica de datos existentes desde vocational_profiles.selected_career_ids
INSERT INTO user_selected_careers (user_id, career_id, preference_order, source)
SELECT 
    vp.user_id, 
    elem.career_id, 
    elem.ord::INTEGER, 
    'TEST_AI'
FROM vocational_profiles vp
CROSS JOIN LATERAL unnest(vp.selected_career_ids) WITH ORDINALITY AS elem(career_id, ord)
ON CONFLICT (user_id, career_id) DO NOTHING;

--rollback DROP TABLE IF EXISTS user_selected_careers CASCADE;
