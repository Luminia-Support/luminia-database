--liquibase formatted sql

--changeset luminia-architect:07-recalculate-gamification-levels runInTransaction:true
--comment: Recálculo de niveles de gamificación de usuarios a partir de la fórmula de curva potencial calibrada: Level = floor((XP / 175.0)^(2/3)) + 1

UPDATE user_gamification
SET current_level = CASE 
        WHEN xp_points <= 0 THEN 1 
        ELSE GREATEST(1, FLOOR(ROUND(POWER(xp_points::numeric / 350.0, 2.0 / 3.0), 6))::integer + 1)
    END,
    updated_at = CURRENT_TIMESTAMP;

--rollback UPDATE user_gamification SET current_level = GREATEST(1, (xp_points / 100) + 1), updated_at = CURRENT_TIMESTAMP;
