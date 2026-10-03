--liquibase formatted sql

--changeset luminia-architect:11-seed-expanded-vocational-swipe-cards runInTransaction:true
--comment: Semilla ampliada de micro-tareas vocacionales balanceadas (42 tarjetas) con etiquetas tematicas

INSERT INTO vocational_swipe_cards (id, task_description, primary_riasec, secondary_riasec, work_environment, icon_name, theme_tag, is_active)
VALUES
    -- ==========================================
    -- REALISTA (R)
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111201', 'Calibrar la telemetria y sensores lidar de un vehiculo electrico autonomo en pista de pruebas', 'R', 'I', 'Pista de pruebas automotriz', 'Cpu', 'TECH_2035', TRUE),
    ('c1111111-1111-1111-1111-111111111202', 'Instalar y configurar paneles solares bifaciales en el techo de un complejo industrial', 'R', 'E', 'Parque solar / Altura', 'Rocket', 'GREEN_FUTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111203', 'Reparar un brazo robotico de alta precision en una planta farmaceutica automatizada', 'R', 'C', 'Planta de manufactura avanzada', 'Cpu', 'TECH_2035', TRUE),
    ('c1111111-1111-1111-1111-111111111204', 'Pilotar un dron con camara termica sobre un glaciar para medir el desprendimiento de hielo', 'R', 'I', 'Zona polar / Campo abierto', 'Compass', 'GREEN_FUTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111205', 'Fabricar una tabla de surf con resinas ecologicas y materiales reciclados del oceano', 'R', 'A', 'Taller artesanal costero', 'Palette', 'GREEN_FUTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111206', 'Manejar maquinaria pesada guiada por GPS para reforestar 50 hectareas de bosque nativo', 'R', 'S', 'Reserva forestal', 'Globe', 'GREEN_FUTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111207', 'Configurar los racks de servidores y cables de fibra optica submarina de un data center', 'R', 'C', 'Centro de datos de alta seguridad', 'Cpu', 'TECH_2035', TRUE),

    -- ==========================================
    -- INVESTIGATIVO (I)
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111208', 'Analizar secuencias de ADN con algoritmos bioinformaticos para encontrar mutaciones raras', 'I', 'R', 'Laboratorio genomico computacional', 'Microscope', 'BIO_HEALTH', TRUE),
    ('c1111111-1111-1111-1111-111111111209', 'Disenar un modelo de redes neuronales para traducir dialectos indigenas en peligro de extincion', 'I', 'A', 'Laboratorio de IA y lenguaje', 'Code', 'TECH_2035', TRUE),
    ('c1111111-1111-1111-1111-111111111210', 'Investigar el comportamiento de hormigas reina para desarrollar soluciones de trafico urbano', 'I', 'S', 'Biopoligono experimental', 'Compass', 'GREEN_FUTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111211', 'Modelar el impacto economico de la adopcion de energias renovables en paises en desarrollo', 'I', 'E', 'Centro de estudios politicos y economicos', 'TrendingUp', 'GREEN_FUTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111212', 'Descubrir una vulnerabilidad zero-day en un sistema operativo movil antes de que los hackers la exploten', 'I', 'C', 'Laboratorio de ciberdefensa', 'ShieldAlert', 'TECH_2035', TRUE),
    ('c1111111-1111-1111-1111-111111111213', 'Sintetizar un nuevo biomaterial derivado de hongos para reemplazar el plastico de embalaje', 'I', 'R', 'Laboratorio de quimica verde', 'Microscope', 'GREEN_FUTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111214', 'Simular la colision de asteroides con la Luna usando supercomputadoras del observatorio', 'I', 'A', 'Instituto astrofisico', 'Globe', 'TECH_2035', TRUE),

    -- ==========================================
    -- ARTISTICO (A)
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111215', 'Esculpir en 3D criaturas mitologicas para una pelicula de animacion nominada a premios internacionales', 'A', 'R', 'Estudio de efectos visuales (VFX)', 'Palette', 'CREATIVE_MEDIA', TRUE),
    ('c1111111-1111-1111-1111-111111111216', 'Componer el paisaje sonoro interactivo que reacciona a las emociones del jugador en un juego de terror', 'A', 'I', 'Estudio acustico inmersivo', 'Music', 'CREATIVE_MEDIA', TRUE),
    ('c1111111-1111-1111-1111-111111111217', 'Escribir una serie de cronicas periodisticas sobre la vida cotidiana de astronautas en aislamiento', 'A', 'S', 'Redaccion editorial / Remoto', 'BookOpen', 'CREATIVE_MEDIA', TRUE),
    ('c1111111-1111-1111-1111-111111111218', 'Dirigir el diseno de vestuario futurista para una obra teatral interactiva donde el publico vota el final', 'A', 'E', 'Teatro de vanguardia y camerinos', 'Palette', 'CREATIVE_MEDIA', TRUE),
    ('c1111111-1111-1111-1111-111111111219', 'Disenar la identidad tipografica y de marca para un museo nacional de arte contemporaneo', 'A', 'C', 'Agencia de branding cultural', 'Palette', 'CREATIVE_MEDIA', TRUE),
    ('c1111111-1111-1111-1111-111111111220', 'Crear una instalacion de arte lumínico que se alimenta del pulso cardiaco de los visitantes', 'A', 'R', 'Galeria de arte interactiva', 'Smile', 'CREATIVE_MEDIA', TRUE),
    ('c1111111-1111-1111-1111-111111111221', 'Ilustrar un comic de divulgacion cientifica sobre como viaja un virus dentro del sistema inmunologico', 'A', 'I', 'Estudio de ilustracion digital', 'Palette', 'BIO_HEALTH', TRUE),

    -- ==========================================
    -- SOCIAL (S)
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111222', 'Guiar a un grupo de adolescentes en un taller de manejo de ansiedad frente a examenes de admision', 'S', 'I', 'Aula de bienestar escolar', 'HeartHandshake', 'CIVIC_SOCIAL', TRUE),
    ('c1111111-1111-1111-1111-111111111223', 'Acompanar la rehabilitacion fisica de un atleta olimpico para que vuelva a caminar sin dolor', 'S', 'R', 'Gimnasio de kinesiologia deportiva', 'Activity', 'BIO_HEALTH', TRUE),
    ('c1111111-1111-1111-1111-111111111224', 'Mediar un acuerdo de convivencia comunitaria entre vecinos de un barrio historico y nuevos locales nocturnos', 'S', 'E', 'Centro civico municipal', 'Users', 'CIVIC_SOCIAL', TRUE),
    ('c1111111-1111-1111-1111-111111111225', 'Capacitar a profesores rurales en el uso de pizarras digitales con internet satelital', 'S', 'C', 'Escuela rural comunitaria', 'BookOpen', 'CIVIC_SOCIAL', TRUE),
    ('c1111111-1111-1111-1111-111111111226', 'Disenar un programa de adopcion de mascotas mayores para personas de la tercera edad solas', 'S', 'A', 'Centro comunitario y refugio', 'Smile', 'CIVIC_SOCIAL', TRUE),
    ('c1111111-1111-1111-1111-111111111227', 'Coordinar la llegada de suministros medicos y tiendas de campana tras un terremoto en zona aislada', 'S', 'R', 'Campamento de ayuda humanitaria', 'HeartHandshake', 'CIVIC_SOCIAL', TRUE),
    ('c1111111-1111-1111-1111-111111111228', 'Realizar terapia asistida con caballos para ninos con dificultades de comunicacion verbal', 'S', 'R', 'Centro ecuestre terapeutico', 'HeartHandshake', 'BIO_HEALTH', TRUE),

    -- ==========================================
    -- EMPRENDEDOR (E)
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111229', 'Convencer a un fondo de inversion de Silicon Valley para financiar tu patente de purificacion de agua', 'E', 'I', 'Auditorio de inversionistas', 'Rocket', 'BUSINESS_VENTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111230', 'Lanzar un festival gastronómico sostenible que reune a 40 chefs emergentes y 10,000 asistentes', 'E', 'A', 'Parque de la ciudad / Eventos', 'TrendingUp', 'BUSINESS_VENTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111231', 'Negociar los derechos de transmision exclusivos de un torneo internacional de eSports', 'E', 'S', 'Hotel de convenciones de lujo', 'Briefcase', 'CREATIVE_MEDIA', TRUE),
    ('c1111111-1111-1111-1111-111111111232', 'Abrir la primera tienda de alquiler de ropa inteligente con pago por uso en el centro comercial', 'E', 'R', 'Local comercial boutique', 'Rocket', 'BUSINESS_VENTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111233', 'Reestructurar la estrategia de ventas de una empresa familiar para que empiece a exportar cafe organico a Europa', 'E', 'C', 'Oficina de comercio exterior', 'Briefcase', 'BUSINESS_VENTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111234', 'Liderar un equipo de 30 voluntarios en una campana de recaudacion de fondos para un hospital pediatrico', 'E', 'S', 'Sede de organizacion benefica', 'Award', 'CIVIC_SOCIAL', TRUE),
    ('c1111111-1111-1111-1111-111111111235', 'Lanzar una marca de suplementos deportivos naturales y cerrar acuerdos con las 5 principales cadenas de farmacias', 'E', 'I', 'Sala de reuniones comercial', 'TrendingUp', 'BIO_HEALTH', TRUE),

    -- ==========================================
    -- CONVENCIONAL (C)
    -- ==========================================
    ('c1111111-1111-1111-1111-111111111236', 'Disenar el sistema de facturacion electronica y conciliacion bancaria de una fintech en crecimiento', 'C', 'I', 'Oficina financiera moderna', 'FileCheck', 'BUSINESS_VENTURE', TRUE),
    ('c1111111-1111-1111-1111-111111111237', 'Auditar los registros de seguridad y mantenimiento de una aerolinea comercial antes de un vuelo transatlantico', 'C', 'R', 'Hangar de mantenimiento aereo', 'ShieldAlert', 'TECH_2035', TRUE),
    ('c1111111-1111-1111-1111-111111111238', 'Clasificar y proteger miles de mapas cartograficos del siglo XVIII en una boveda de museo con clima controlado', 'C', 'A', 'Archivo historico de conservacion', 'Archive', 'CIVIC_SOCIAL', TRUE),
    ('c1111111-1111-1111-1111-111111111239', 'Supervisar el estricto cumplimiento legal de proteccion de datos personales (RGPD) en una app de salud', 'C', 'S', 'Departamento legal corporativo', 'Scale', 'BIO_HEALTH', TRUE),
    ('c1111111-1111-1111-1111-111111111240', 'Administrar el inventario critico de farmacos oncologicos en el hospital para que nunca falte una dosis', 'C', 'I', 'Farmacia central hospitalaria', 'FileCheck', 'BIO_HEALTH', TRUE),
    ('c1111111-1111-1111-1111-111111111241', 'Configurar las politicas de control de acceso y contrasenas de 5,000 empleados en la nube corporativa', 'C', 'R', 'Oficina de sistemas IT', 'ShieldAlert', 'TECH_2035', TRUE),
    ('c1111111-1111-1111-1111-111111111242', 'Calcular la proyeccion actuarial y riesgo de pensiones para miles de jubilados durante los proximos 30 anos', 'C', 'E', 'Firma de actuaria y seguros', 'FileCheck', 'BUSINESS_VENTURE', TRUE)
ON CONFLICT (id) DO NOTHING;

--rollback DELETE FROM vocational_swipe_cards WHERE id::text LIKE 'c1111111-1111-1111-1111-1111111112%';
