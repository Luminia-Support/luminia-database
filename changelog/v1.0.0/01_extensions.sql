--liquibase formatted sql

--changeset luminia-architect:01-extensions runInTransaction:true
--comment: Habilitar extensiones necesarias para PostGIS, Vectores (IA con pgvector) y UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";
CREATE EXTENSION IF NOT EXISTS "vector";

--rollback DROP EXTENSION IF EXISTS "vector";
--rollback DROP EXTENSION IF EXISTS "postgis";
--rollback DROP EXTENSION IF EXISTS "uuid-ossp";
