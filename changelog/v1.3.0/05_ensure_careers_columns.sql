--liquibase formatted sql

--changeset luminia-architect:05-ensure-careers-columns runInTransaction:true
--comment: Asegurar columnas embedding_text y geographic_scope en careers

ALTER TABLE careers ADD COLUMN IF NOT EXISTS embedding_text TEXT;
ALTER TABLE careers ADD COLUMN IF NOT EXISTS geographic_scope SMALLINT DEFAULT 3;

--rollback ALTER TABLE careers DROP COLUMN IF EXISTS embedding_text;
--rollback ALTER TABLE careers DROP COLUMN IF EXISTS geographic_scope;

--changeset luminia-architect:06-pgvector-implicit-casts runInTransaction:true splitStatements:false
--comment: Casts implicitos para compatibilidad con pgvector y JPA

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_cast WHERE castsource = 'varchar'::regtype AND casttarget = 'vector'::regtype) THEN
        CREATE CAST (character varying AS vector) WITH INOUT AS IMPLICIT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_cast WHERE castsource = 'text'::regtype AND casttarget = 'vector'::regtype) THEN
        CREATE CAST (text AS vector) WITH INOUT AS IMPLICIT;
    END IF;
END $$;

--rollback DROP CAST IF EXISTS (character varying AS vector);
--rollback DROP CAST IF EXISTS (text AS vector);
