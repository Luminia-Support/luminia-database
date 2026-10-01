--liquibase formatted sql

--changeset luminia-architect:03-academic-catalog runInTransaction:true
--comment: Creación del catálogo académico (países, tipos de institución, instituciones, sedes, carreras y pathways)

CREATE TABLE IF NOT EXISTS countries (
    id SERIAL PRIMARY KEY,
    iso_code VARCHAR(2) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS institution_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS institutions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    institution_type_id INTEGER NOT NULL REFERENCES institution_types(id),
    country_id INTEGER NOT NULL REFERENCES countries(id),
    logo_url VARCHAR(255),
    website_url VARCHAR(255),
    tier_level INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS campuses (
    id SERIAL PRIMARY KEY,
    institution_id INTEGER NOT NULL REFERENCES institutions(id),
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255),
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    location GEOGRAPHY(Point, 4326)
);

CREATE TABLE IF NOT EXISTS careers (
    id SERIAL PRIMARY KEY,
    cip_code VARCHAR(20) UNIQUE,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    embedding_text TEXT,
    market_demand VARCHAR(50),
    avg_salary_range VARCHAR(100),
    geographic_scope SMALLINT NOT NULL DEFAULT 3,
    embedding vector(1536)
);

CREATE TABLE IF NOT EXISTS educational_pathways (
    id SERIAL PRIMARY KEY,
    career_id INTEGER NOT NULL REFERENCES careers(id),
    institution_id INTEGER NOT NULL REFERENCES institutions(id),
    campus_id INTEGER REFERENCES campuses(id),
    program_name VARCHAR(255) NOT NULL,
    duration VARCHAR(100),
    modality VARCHAR(50)
);

--rollback DROP TABLE IF EXISTS educational_pathways CASCADE;
--rollback DROP TABLE IF EXISTS careers CASCADE;
--rollback DROP TABLE IF EXISTS campuses CASCADE;
--rollback DROP TABLE IF EXISTS institutions CASCADE;
--rollback DROP TABLE IF EXISTS institution_types CASCADE;
--rollback DROP TABLE IF EXISTS countries CASCADE;
