--liquibase formatted sql

--changeset luminia-architect:13-separate-general-and-thematic-cards runInTransaction:true
--comment: Separacion estricta: tarjetas base a generales (theme_tag = NULL) y siembra adicional de 18 tarjetas generales

-- 1. Restablecer las 20 tarjetas base iniciales como generales (sin tema)
UPDATE vocational_swipe_cards
SET theme_tag = NULL
WHERE id::text LIKE 'c1111111-1111-1111-1111-1111111111%';

-- 2. Sembrar 18 tarjetas vocacionales generales adicionales (3 por letra RIASEC) con theme_tag = NULL
INSERT INTO vocational_swipe_cards (id, task_description, primary_riasec, secondary_riasec, work_environment, icon_name, theme_tag, is_active)
VALUES
    -- ==========================================
    -- REALISTA (R) - General
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111301', 'Inspeccionar y verificar las conexiones electricas principales de un edificio comercial nuevo', 'R', 'C', 'Edificio en construccion / Sala tecnica', 'Cpu', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111302', 'Operar un torno de control numerico (CNC) para modelar piezas metalicas con precision micrometrica', 'R', 'I', 'Taller mecanico industrial', 'Cpu', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111303', 'Instalar sistemas de aire acondicionado central en un hospital asegurando filtros de aire esteril', 'R', 'S', 'Hospital / Ductos de ventilacion', 'Activity', NULL, TRUE),

    -- ==========================================
    -- INVESTIGATIVO (I) - General
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111304', 'Disenar un protocolo experimental para medir la tasa de absorcion de agua en suelos agricolas', 'I', 'R', 'Laboratorio de agronomia y campo', 'Compass', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111305', 'Depurar un error critico de concurrencia en una base de datos distribuida antes del lanzamiento', 'I', 'C', 'Oficina de ingenieria de software', 'Code', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111306', 'Evaluar estadisticamente la efectividad de un nuevo tratamiento analgesico en 500 pacientes', 'I', 'S', 'Centro de investigacion clinica', 'Microscope', NULL, TRUE),

    -- ==========================================
    -- ARTISTICO (A) - General
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111307', 'Crear bocetos y definir la paleta cromatica para la identidad visual de una marca de alimentos', 'A', 'E', 'Estudio de diseno y branding', 'Palette', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111308', 'Adaptar un guion teatral clasico para una puesta en escena contemporanea al aire libre', 'A', 'S', 'Espacio cultural abierto', 'BookOpen', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111309', 'Fotografiar retratos expresivos de artesanos locales para una exposicion cultural itinerante', 'A', 'R', 'Taller tradicional y estudio fotografico', 'Smile', NULL, TRUE),

    -- ==========================================
    -- SOCIAL (S) - General
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111310', 'Organizar un circulo de debate para estudiantes de secundaria sobre resolucion pacifica de conflictos', 'S', 'I', 'Biblioteca escolar', 'Users', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111311', 'Guiar a una familia en el proceso de solicitud de apoyo estatal para vivienda social', 'S', 'C', 'Oficina de atencion ciudadana', 'HeartHandshake', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111312', 'Facilitar una sesion de integracion y bienvenida para nuevos residentes en un centro comunitario', 'S', 'A', 'Salon comunitario municipal', 'Smile', NULL, TRUE),

    -- ==========================================
    -- EMPRENDEDOR (E) - General
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111313', 'Presentar los beneficios de un nuevo software logistico al comite de compras de una empresa', 'E', 'I', 'Sala de conferencias ejecutiva', 'Briefcase', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111314', 'Negociar los terminos de arrendamiento y condiciones de pago para un nuevo local comercial', 'E', 'C', 'Oficina de administracion de bienes raices', 'TrendingUp', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111315', 'Coordinar con patrocinadores y medios de comunicacion la rueda de prensa de una carrera benefica', 'E', 'S', 'Sala de prensa y eventos', 'Award', NULL, TRUE),

    -- ==========================================
    -- CONVENCIONAL (C) - General
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111316', 'Conciliar los estados de cuenta bancarios y detectar discrepancias en el cierre contable mensual', 'C', 'E', 'Departamento de finanzas corporativo', 'FileCheck', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111317', 'Estandarizar los manuales de operacion y control de calidad de un laboratorio de analisis de agua', 'C', 'I', 'Oficina de control de calidad', 'FileCheck', NULL, TRUE),
    ('c1111111-1111-1111-1111-111111111318', 'Catalogar y registrar las referencias bibliograficas y metadatos de 1,000 tesis de investigacion', 'C', 'S', 'Centro de documentacion universitaria', 'Archive', NULL, TRUE)
ON CONFLICT (id) DO NOTHING;

-- 3. Crear indice parcial para busqueda ultra-rapida de tarjetas generales (theme_tag IS NULL)
CREATE INDEX IF NOT EXISTS idx_vocational_swipe_cards_general 
ON vocational_swipe_cards(primary_riasec) WHERE is_active = TRUE AND theme_tag IS NULL;

--rollback DROP INDEX IF EXISTS idx_vocational_swipe_cards_general;
--rollback DELETE FROM vocational_swipe_cards WHERE id::text LIKE 'c1111111-1111-1111-1111-1111111113%';
