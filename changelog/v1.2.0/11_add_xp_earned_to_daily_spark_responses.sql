--liquibase formatted sql

--changeset luminia-architect:11-add-xp-earned-to-daily-spark-responses runInTransaction:true
--comment: Persistencia de puntos de experiencia (xp_earned) obtenidos por cada respuesta en daily_spark_responses

-- 1. Agregar columna xp_earned en daily_spark_responses con valor por defecto 25
ALTER TABLE daily_spark_responses 
    ADD COLUMN IF NOT EXISTS xp_earned INTEGER NOT NULL DEFAULT 25;

-- 2. Backfill para respuestas que fueron de rescate (30 XP) o respondidas el mismo día de activación (30 XP)
UPDATE daily_spark_responses r
SET xp_earned = 30
FROM daily_sparks s
WHERE r.spark_id = s.id
  AND (r.is_rescue_response = true OR s.active_date = r.responded_at::date);

--rollback ALTER TABLE daily_spark_responses DROP COLUMN IF EXISTS xp_earned;
