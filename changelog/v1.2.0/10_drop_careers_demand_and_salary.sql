--liquibase formatted sql

--changeset luminia-architect:10-drop-careers-demand-and-salary runInTransaction:true
--comment: Drop market_demand and avg_salary_range from careers table

ALTER TABLE careers DROP COLUMN IF EXISTS market_demand;
ALTER TABLE careers DROP COLUMN IF EXISTS avg_salary_range;

--rollback ALTER TABLE careers ADD COLUMN IF NOT EXISTS market_demand VARCHAR(50);
--rollback ALTER TABLE careers ADD COLUMN IF NOT EXISTS avg_salary_range VARCHAR(100);
