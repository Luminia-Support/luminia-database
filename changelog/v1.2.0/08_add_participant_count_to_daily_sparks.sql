--liquibase formatted sql

--changeset luminia-architect:08-add-participant-count-to-daily-sparks runInTransaction:true
--comment: Contador persistente de participantes comunitarios en daily_sparks y backfill inicial

-- 1. Agregar columna participant_count en daily_sparks
ALTER TABLE daily_sparks 
    ADD COLUMN IF NOT EXISTS participant_count INTEGER NOT NULL DEFAULT 0;

-- 2. Backfill inicial con el número de respuestas ya registradas
UPDATE daily_sparks s
SET participant_count = COALESCE((
    SELECT COUNT(*) 
    FROM daily_spark_responses r 
    WHERE r.spark_id = s.id
), 0);

--rollback ALTER TABLE daily_sparks DROP COLUMN IF EXISTS participant_count;
