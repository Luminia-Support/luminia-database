--liquibase formatted sql

--changeset luminia-architect:10-user-deck-sessions-and-theme-tags runInTransaction:true
--comment: Tabla de sesiones de mazos vocacionales con estado numerico y soporte de temas para swipes

-- 1. Agregar columna theme_tag en vocational_swipe_cards para eventos tematicos
ALTER TABLE vocational_swipe_cards 
ADD COLUMN IF NOT EXISTS theme_tag VARCHAR(50) DEFAULT NULL;

CREATE INDEX IF NOT EXISTS idx_vocational_swipe_cards_theme 
ON vocational_swipe_cards(theme_tag) WHERE is_active = TRUE;

-- 2. Crear tabla de sesiones de mazo
CREATE TABLE IF NOT EXISTS user_deck_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    deck_type VARCHAR(20) NOT NULL DEFAULT 'GENERAL',
    card_ids UUID[] NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    play_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    completed_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT chk_deck_session_status CHECK (status IN (1, 2))
);

-- 3. Indice Unico Parcial: Solo puede existir 1 mazo en estado OPEN (1) por usuario
CREATE UNIQUE INDEX IF NOT EXISTS ux_deck_session_open 
ON user_deck_sessions(user_id) WHERE status = 1;

-- 4. Indice Parcial para auditoria y calculo de cuotas sobre sesiones COMPLETED (2)
CREATE INDEX IF NOT EXISTS idx_deck_sessions_user_date 
ON user_deck_sessions(user_id, play_date) WHERE status = 2;

--rollback DROP TABLE IF EXISTS user_deck_sessions CASCADE;
--rollback DROP INDEX IF EXISTS idx_vocational_swipe_cards_theme;
--rollback ALTER TABLE vocational_swipe_cards DROP COLUMN IF EXISTS theme_tag;
