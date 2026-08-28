--liquibase formatted sql

--changeset luminia-architect:05-seed-reference-data runInTransaction:true
--comment: Carga inicial de datos maestros / catálogos de referencia (Países y Tipos de Institución)

INSERT INTO countries (id, iso_code, name) 
VALUES (1, 'PE', 'Perú')
ON CONFLICT (id) DO UPDATE SET 
    iso_code = EXCLUDED.iso_code, 
    name = EXCLUDED.name;

SELECT setval('countries_id_seq', (SELECT COALESCE(MAX(id), 1) FROM countries));

INSERT INTO institution_types (id, name, description) 
VALUES 
    (1, 'Universidad', 'Universidades'),
    (2, 'Instituto', 'Institutos')
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    description = EXCLUDED.description;

SELECT setval('institution_types_id_seq', (SELECT COALESCE(MAX(id), 2) FROM institution_types));

--rollback DELETE FROM institution_types WHERE id IN (1, 2);
--rollback DELETE FROM countries WHERE id IN (1);
