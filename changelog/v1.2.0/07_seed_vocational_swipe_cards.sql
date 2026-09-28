--liquibase formatted sql

--changeset luminia-architect:07-seed-vocational-swipe-cards runInTransaction:true
--comment: Semilla inicial de micro-tareas vocacionales para el mazo de Swipes diarios

INSERT INTO vocational_swipe_cards (id, task_description, primary_riasec, secondary_riasec, work_environment, icon_name, is_active)
VALUES
    ('c1111111-1111-1111-1111-111111111101', 'Diseñar la interfaz y animaciones de una app móvil para que adultos mayores no se confundan', 'A', 'I', 'Estudio de diseño / Remoto', 'Palette', TRUE),
    ('c1111111-1111-1111-1111-111111111102', 'Pasar 4 horas en silencio analizando anomalías en un cultivo bacteriológico con microscopio', 'I', 'R', 'Laboratorio clínico estéril', 'Microscope', TRUE),
    ('c1111111-1111-1111-1111-111111111103', 'Negociar un presupuesto tenso de $50,000 entre dos directores de empresa en desacuerdo', 'E', 'S', 'Sala de juntas corporativa', 'Briefcase', TRUE),
    ('c1111111-1111-1111-1111-111111111104', 'Mediar en una sesión emocional difícil entre un adolescente en crisis y sus padres', 'S', 'I', 'Consultorio psicológico acogedor', 'HeartHandshake', TRUE),
    ('c1111111-1111-1111-1111-111111111105', 'Construir y soldar los sensores de un dron autónomo que detecta incendios forestales', 'R', 'I', 'Taller de robótica y campo abierto', 'Cpu', TRUE),
    ('c1111111-1111-1111-1111-111111111106', 'Auditar minuciosamente miles de transacciones contables para descubrir un fraude financiero oculto', 'C', 'I', 'Oficina de auditoría con pantallas dobles', 'FileCheck', TRUE),
    ('c1111111-1111-1111-1111-111111111107', 'Crear la banda sonora y los efectos de sonido envolventes para una escena de terror en un videojuego', 'A', 'R', 'Estudio de grabación insonorizado', 'Music', TRUE),
    ('c1111111-1111-1111-1111-111111111108', 'Defender ante un juez un recurso de protección para salvar un humedal amenazado por una constructora', 'E', 'S', 'Tribunal de justicia / Juzgado', 'Scale', TRUE),
    ('c1111111-1111-1111-1111-111111111109', 'Organizar un campamento comunitario de primeros auxilios y salud preventiva en una zona rural', 'S', 'R', 'Comunidad al aire libre', 'Users', TRUE),
    ('c1111111-1111-1111-1111-111111111110', 'Optimizar el algoritmo de recomendaciones de una plataforma de streaming para predecir qué canción quieres escuchar', 'I', 'C', 'Oficina tecnológica moderna', 'Code', TRUE),
    ('c1111111-1111-1111-1111-111111111111', 'Operar instrumental quirúrgico en una cirugía de urgencia manteniendo la calma bajo presión', 'R', 'S', 'Quirófano hospitalario de alta tecnología', 'Activity', TRUE),
    ('c1111111-1111-1111-1111-111111111112', 'Liderar una campaña de marketing digital en TikTok para posicionar una nueva marca de ropa sostenible', 'E', 'A', 'Agencia creativa dinámica', 'TrendingUp', TRUE),
    ('c1111111-1111-1111-1111-111111111113', 'Escribir el guión de diálogos y decisiones ramificadas para los personajes de un juego RPG narrativo', 'A', 'S', 'Café o espacio de co-working', 'BookOpen', TRUE),
    ('c1111111-1111-1111-1111-111111111114', 'Investigar restos fósiles en una excavación desértica para reconstruir un ecosistema prehistórico', 'I', 'R', 'Sitio arqueológico al aire libre', 'Compass', TRUE),
    ('c1111111-1111-1111-1111-111111111115', 'Supervisar el protocolo de ciberseguridad para detener un ciberataque en vivo a una red hospitalaria', 'C', 'R', 'Centro de operaciones de seguridad (SOC)', 'ShieldAlert', TRUE),
    ('c1111111-1111-1111-1111-111111111116', 'Diseñar prótesis biónicas personalizadas con impresión 3D para niños con amputaciones', 'R', 'A', 'Laboratorio biomecánico', 'Smile', TRUE),
    ('c1111111-1111-1111-1111-111111111117', 'Entrenar y motivar a un equipo deportivo juvenil que viene de perder tres partidos seguidos', 'S', 'E', 'Cancha de entrenamiento', 'Award', TRUE),
    ('c1111111-1111-1111-1111-111111111118', 'Crear modelos matemáticos para predecir la trayectoria de tormentas solares y su impacto en satélites', 'I', 'C', 'Observatorio astronómico', 'Globe', TRUE),
    ('c1111111-1111-1111-1111-111111111119', 'Lanzar tu propia startup de entrega de comida saludable en bicicleta y convencer a los primeros 10 restaurantes', 'E', 'R', 'Calles de la ciudad / Oficina improvisada', 'Rocket', TRUE),
    ('c1111111-1111-1111-1111-111111111120', 'Organizar y digitalizar el archivo histórico de una biblioteca nacional para que no se pierdan documentos de 200 años', 'C', 'S', 'Bóveda de archivo histórico', 'Archive', TRUE)
ON CONFLICT (id) DO NOTHING;

--rollback DELETE FROM vocational_swipe_cards WHERE id LIKE 'c1111111-1111-1111-1111-1111111111%';
