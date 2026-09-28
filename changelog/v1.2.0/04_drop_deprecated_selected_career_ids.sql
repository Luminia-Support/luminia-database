--liquibase formatted sql

--changeset luminia-architect:04-drop-deprecated-selected-career-ids runInTransaction:true
--comment: Contract phase: Drop deprecated selected_career_ids column from vocational_profiles

ALTER TABLE vocational_profiles DROP COLUMN IF EXISTS selected_career_ids;

--rollback ALTER TABLE vocational_profiles ADD COLUMN IF NOT EXISTS selected_career_ids INTEGER[] DEFAULT '{}';
