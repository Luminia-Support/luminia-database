--liquibase formatted sql

--changeset luminia-architect:01-gamification-schema runInTransaction:true
--comment: Creación de tablas de gamificación, retos diarios (Daily Sparks), respuestas y simulaciones vocacionales (Career Quests)

-- 1. Tabla de Estado de Gamificación de Usuario
CREATE TABLE IF NOT EXISTS user_gamification (
    user_id UUID PRIMARY KEY REFERENCES user_profiles(id) ON DELETE CASCADE,
    xp_points INTEGER NOT NULL DEFAULT 0,
    current_level INTEGER NOT NULL DEFAULT 1,
    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    last_activity_date DATE,
    streak_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    quest_keys INTEGER NOT NULL DEFAULT 1,
    sparks_progress INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_streak_status CHECK (streak_status IN ('ACTIVE', 'AT_RISK', 'RECOVERED')),
    CONSTRAINT chk_xp_points CHECK (xp_points >= 0),
    CONSTRAINT chk_current_level CHECK (current_level >= 1),
    CONSTRAINT chk_quest_keys CHECK (quest_keys >= 0),
    CONSTRAINT chk_sparks_progress CHECK (sparks_progress >= 0)
);

-- 2. Tabla de Retos Diarios (Daily Sparks)
CREATE TABLE IF NOT EXISTS daily_sparks (
    id SERIAL PRIMARY KEY,
    active_date DATE UNIQUE NOT NULL,
    category VARCHAR(50) NOT NULL,
    title VARCHAR(150) NOT NULL,
    prompt_text TEXT NOT NULL,
    options JSONB NOT NULL,
    fact_explanation TEXT,
    xp_reward INTEGER NOT NULL DEFAULT 30,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_spark_category CHECK (category IN (
        'DILEMMA_WORK_VALUES',
        'MYTH_VS_REALITY',
        'MULTI_CHOICE_RIASEC',
        'AI_FUTURE_TRENDS',
        'INDUSTRY_CULTURE',
        'PRACTICAL_MICRO_ACTION',
        'ETHICAL_DILEMMA'
    ))
);

-- 3. Tabla de Respuestas a Retos Diarios
CREATE TABLE IF NOT EXISTS daily_spark_responses (
    id BIGSERIAL PRIMARY KEY,
    spark_id INTEGER NOT NULL REFERENCES daily_sparks(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    chosen_option VARCHAR(10) NOT NULL,
    is_rescue_response BOOLEAN NOT NULL DEFAULT FALSE,
    responded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_daily_spark_user UNIQUE (spark_id, user_id)
);

-- 4. Tabla de Bitácora de Simulaciones de Rol Vocacionales (Career Quests)
CREATE TABLE IF NOT EXISTS user_career_simulations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    role_name VARCHAR(150) NOT NULL,
    associated_career_id INTEGER REFERENCES careers(id) ON DELETE SET NULL,
    turns_completed INTEGER NOT NULL DEFAULT 3,
    decisions_summary JSONB NOT NULL,
    discovered_traits JSONB NOT NULL,
    feedback_reflection TEXT,
    xp_earned INTEGER NOT NULL DEFAULT 150,
    completed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5. Índices de Alto Rendimiento
CREATE INDEX IF NOT EXISTS idx_daily_sparks_active_date ON daily_sparks(active_date);
CREATE INDEX IF NOT EXISTS idx_daily_spark_responses_user ON daily_spark_responses(user_id, responded_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_career_simulations_user ON user_career_simulations(user_id, completed_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_career_simulations_career ON user_career_simulations(associated_career_id);

--rollback DROP INDEX IF EXISTS idx_user_career_simulations_career;
--rollback DROP INDEX IF EXISTS idx_user_career_simulations_user;
--rollback DROP INDEX IF EXISTS idx_daily_spark_responses_user;
--rollback DROP INDEX IF EXISTS idx_daily_sparks_active_date;
--rollback DROP TABLE IF EXISTS user_career_simulations CASCADE;
--rollback DROP TABLE IF EXISTS daily_spark_responses CASCADE;
--rollback DROP TABLE IF EXISTS daily_sparks CASCADE;
--rollback DROP TABLE IF EXISTS user_gamification CASCADE;
