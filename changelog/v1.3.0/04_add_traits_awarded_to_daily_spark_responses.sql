--liquibase formatted sql

--changeset luminia-architect:04-add-traits-awarded-to-daily-spark-responses runInTransaction:true
--comment: Persistencia inmutable de puntos RIASEC/rasgos otorgados por respuesta a reto diario

-- 1. Agregar columna traits_awarded en daily_spark_responses con valor por defecto {}
ALTER TABLE daily_spark_responses 
    ADD COLUMN IF NOT EXISTS traits_awarded JSONB NOT NULL DEFAULT '{}'::jsonb;

-- 2. Backfill historico correlacionando con el catalogo daily_sparks
UPDATE daily_spark_responses r
SET traits_awarded = COALESCE(sub.traits, '{}'::jsonb)
FROM (
    SELECT 
        r2.id AS response_id,
        opt->'traitWeights' AS traits
    FROM daily_spark_responses r2
    JOIN daily_sparks s ON s.id = r2.spark_id
    CROSS JOIN LATERAL jsonb_array_elements(s.options) AS opt
    WHERE UPPER(TRIM(opt->>'id')) = UPPER(TRIM(r2.chosen_option))
      AND opt -> 'traitWeights' IS NOT NULL
) sub
WHERE r.id = sub.response_id;

--rollback ALTER TABLE daily_spark_responses DROP COLUMN IF EXISTS traits_awarded;
