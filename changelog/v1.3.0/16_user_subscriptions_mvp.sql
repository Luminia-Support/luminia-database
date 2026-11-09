--liquibase formatted sql

--changeset luminia-architect:16-user-subscriptions-mvp runInTransaction:true
--comment: Modelo de suscripcion manual MVP, configuracion dinamica de precios, cuotas de llaves diferidas para plan anual y control de acceso

-- 1. Campos de suscripción en user_profiles
ALTER TABLE user_profiles
    ADD COLUMN IF NOT EXISTS subscription_plan VARCHAR(30) NOT NULL DEFAULT 'FREE_TRIAL',
    ADD COLUMN IF NOT EXISTS access_expires_at TIMESTAMP NULL,
    ADD COLUMN IF NOT EXISTS subscription_updated_at TIMESTAMP NULL;

-- 2. Migración retroactiva: para usuarios ya registrados, 30 días desde quota_claimed_at si existe, o 30 días desde ahora
UPDATE user_profiles
SET subscription_plan = 'FREE_TRIAL',
    access_expires_at = COALESCE(quota_claimed_at, CURRENT_TIMESTAMP) + INTERVAL '30 days'
WHERE access_expires_at IS NULL;

-- 3. Índice para consultas y filtros por plan y fecha de vencimiento
CREATE INDEX IF NOT EXISTS idx_user_profiles_subscription ON user_profiles (subscription_plan, access_expires_at);

-- 4. Tabla de configuración centralizada de suscripciones, precios y llaves de bonificación
CREATE TABLE IF NOT EXISTS platform_subscription_config (
    id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
    free_trial_days INT NOT NULL DEFAULT 30 CHECK (free_trial_days > 0),
    monthly_regular_price NUMERIC(10,2) NOT NULL DEFAULT 19.90 CHECK (monthly_regular_price >= 0),
    monthly_promo_price NUMERIC(10,2) NOT NULL DEFAULT 10.90 CHECK (monthly_promo_price >= 0),
    annual_regular_price NUMERIC(10,2) NOT NULL DEFAULT 180.00 CHECK (annual_regular_price >= 0),
    annual_promo_price NUMERIC(10,2) NOT NULL DEFAULT 110.00 CHECK (annual_promo_price >= 0),
    promo_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    bonus_keys_per_month INT NOT NULL DEFAULT 5 CHECK (bonus_keys_per_month >= 0),
    support_whatsapp VARCHAR(50) DEFAULT '+51999999999',
    updated_by VARCHAR(128),
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO platform_subscription_config (
    id, free_trial_days, monthly_regular_price, monthly_promo_price,
    annual_regular_price, annual_promo_price, promo_enabled, bonus_keys_per_month, support_whatsapp
) VALUES (
    1, 30, 19.90, 10.90, 180.00, 110.00, TRUE, 5, '+51999999999'
) ON CONFLICT (id) DO NOTHING;

-- 5. Campos en user_gamification para entrega progresiva de llaves en plan anual (Opción A)
ALTER TABLE user_gamification
    ADD COLUMN IF NOT EXISTS pending_subscription_key_months INT NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS next_key_grant_at TIMESTAMP NULL;

--rollback ALTER TABLE user_gamification DROP COLUMN IF EXISTS next_key_grant_at, DROP COLUMN IF EXISTS pending_subscription_key_months;
--rollback DROP TABLE IF EXISTS platform_subscription_config;
--rollback DROP INDEX IF EXISTS idx_user_profiles_subscription;
--rollback ALTER TABLE user_profiles DROP COLUMN IF EXISTS subscription_updated_at, DROP COLUMN IF EXISTS access_expires_at, DROP COLUMN IF EXISTS subscription_plan;
