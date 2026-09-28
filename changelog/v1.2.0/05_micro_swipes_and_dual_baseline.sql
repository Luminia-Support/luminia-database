--liquibase formatted sql

--changeset luminia-architect:05-micro-swipes-and-dual-baseline runInTransaction:true
--comment: Línea Base Dual (RIASEC + EQ) y modelo relacional para Vocational Micro-Swipes

-- 1. Línea Base Dual en vocational_profiles
ALTER TABLE vocational_profiles 
    ADD COLUMN IF NOT EXISTS baseline_riasec JSONB DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS baseline_eq JSONB DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS baseline_completed_at TIMESTAMP DEFAULT NULL;

-- 2. Banco curado de tarjetas de micro-tareas vocacionales
CREATE TABLE IF NOT EXISTS vocational_swipe_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_description TEXT NOT NULL,
    primary_riasec VARCHAR(1) NOT NULL,
    secondary_riasec VARCHAR(1),
    career_id INTEGER REFERENCES careers(id) ON DELETE SET NULL,
    work_environment VARCHAR(100),
    icon_name VARCHAR(50) DEFAULT 'Sparkles',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_swipe_primary_riasec CHECK (primary_riasec IN ('R', 'I', 'A', 'S', 'E', 'C')),
    CONSTRAINT chk_swipe_secondary_riasec CHECK (secondary_riasec IS NULL OR secondary_riasec IN ('R', 'I', 'A', 'S', 'E', 'C'))
);

-- 3. Historial de decisiones de swipes de los usuarios
CREATE TABLE IF NOT EXISTS user_swipe_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    card_id UUID NOT NULL REFERENCES vocational_swipe_cards(id) ON DELETE CASCADE,
    action VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_user_swipe_card UNIQUE (user_id, card_id),
    CONSTRAINT chk_swipe_action CHECK (action IN ('LIKE', 'DISLIKE', 'CURIOUS'))
);

-- 4. Índices de alta concurrencia
CREATE INDEX IF NOT EXISTS idx_user_swipe_history_user ON user_swipe_history(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_vocational_swipe_cards_active ON vocational_swipe_cards(is_active, primary_riasec);
CREATE INDEX IF NOT EXISTS idx_vocational_swipe_cards_career ON vocational_swipe_cards(career_id);

--rollback DROP TABLE IF EXISTS user_swipe_history CASCADE;
--rollback DROP TABLE IF EXISTS vocational_swipe_cards CASCADE;
--rollback ALTER TABLE vocational_profiles DROP COLUMN IF EXISTS baseline_completed_at;
--rollback ALTER TABLE vocational_profiles DROP COLUMN IF EXISTS baseline_eq;
--rollback ALTER TABLE vocational_profiles DROP COLUMN IF EXISTS baseline_riasec;
