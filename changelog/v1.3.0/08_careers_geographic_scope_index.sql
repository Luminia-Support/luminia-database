--liquibase formatted sql

--changeset luminia-architect:08-careers-geographic-scope-index runInTransaction:true
--comment: Indice de busqueda y filtrado por alcance geografico en careers

CREATE INDEX IF NOT EXISTS idx_careers_geographic_scope ON careers(geographic_scope);

--rollback DROP INDEX IF EXISTS idx_careers_geographic_scope;
