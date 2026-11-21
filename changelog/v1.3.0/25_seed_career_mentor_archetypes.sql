--liquibase formatted sql

--changeset luminia-architect:25-seed-career-mentor-archetypes runInTransaction:true
--comment: Poblar arquetipos de mentores jóvenes (Reverse Shadowing) para las 71 carreras del catálogo con citas reales enfocadas en adolescentes

INSERT INTO career_mentor_archetypes (
    id,
    career_id,
    mentor_name,
    years_of_experience,
    specialty,
    bio,
    is_active
)
SELECT
    v.id::uuid,
    c.id,
    v.mentor_name,
    v.years_of_experience,
    v.specialty,
    v.bio,
    TRUE
FROM (
    VALUES
    ('a1111111-1111-4111-8111-000000000001', 'Educación', 'Camila Navarro', 4, 'Egresada de Educación', 'Enseñar no es repetir diapositivas: es descifrar cómo aprende cada persona. Pregúntame sin filtro cómo es el aula real, el estrés y cuánto se gana al empezar.'),
    ('a1111111-1111-4111-8111-000000000002', 'Diseño Gráfico', 'Valeria Paredes', 4, 'Egresada de Diseño Gráfico', 'No es solo hacer cosas bonitas ni usar IA: toca defender tus ideas frente a clientes difíciles. Pregúntame cómo armar portafolio y si realmente se vive bien del diseño.'),
    ('a1111111-1111-4111-8111-000000000003', 'Diseño de Videojuegos', 'Sebastián Quispe', 3, 'Egresado de Diseño de Videojuegos', 'Crear juegos no es pasarte el día jugando: es iterar mecánicas y cazar bugs hasta tarde, pero ver a alguien disfrutar tu nivel no tiene precio. Pregúntame sin filtro.'),
    ('a1111111-1111-4111-8111-000000000004', 'Diseño Industrial', 'Lucía Benítez', 4, 'Egresada de Diseño Industrial', 'Pasas del boceto en papel a pelearte con materiales, costos y prototipos 3D. Si te intriga cómo se crean los objetos que usas a diario, pregúntame la verdad del sector.'),
    ('a1111111-1111-4111-8111-000000000005', 'Historia', 'Andrés Morales', 4, 'Egresado de Historia', 'Todos preguntan "¿y de qué vas a vivir?" y aquí te cuento la posta: archivos, investigación, cultura y docencia. Pregúntame sin tabúes sobre el campo laboral real.'),
    ('a1111111-1111-4111-8111-000000000006', 'Traducción e Interpretación', 'Renata Delgado', 3, 'Egresada de Traducción e Interpretación', 'Saber inglés no alcanza: hoy competimos y colaboramos con la IA en textos técnicos y cabinas en vivo. Pregúntame cómo se consigue trabajo freelance y cuánto pagan.'),
    ('a1111111-1111-4111-8111-000000000007', 'Economía', 'Rodrigo Salazar', 4, 'Egresado de Economía', 'Hay bastante matemática y datos, pero entiendes cómo se mueve el dinero y el país de verdad. Pregúntame por los cursos filtro, prácticas pagadas y sueldos de inicio.'),
    ('a1111111-1111-4111-8111-000000000008', 'Ciencias Políticas', 'Mariana Córdova', 4, 'Egresada de Ciencias Políticas', 'No todo es postular a un cargo: trabajamos en políticas públicas, consultoría y análisis social. Pregúntame cómo es el día a día y cómo entrar sin tener contactos.'),
    ('a1111111-1111-4111-8111-000000000009', 'Psicología', 'Sofía Herrera', 4, 'Egresada de Psicología', 'Estudiar psicología no es "leer mentes" y aprender a no llevarte los problemas a casa cuesta al inicio. Pregúntame sobre clínica, empresas y cuánto tardas en despegarte.'),
    ('a1111111-1111-4111-8111-000000000010', 'Sociología', 'Gabriel Fuentes', 4, 'Egresado de Sociología', 'Salimos mucho a campo y analizamos datos para entender por qué la gente actúa como actúa. Pregúntame dónde trabajamos realmente y qué habilidades te abren puertas.'),
    ('a1111111-1111-4111-8111-000000000011', 'Ciencias de la Comunicación', 'Daniela Vega', 3, 'Egresada de Ciencias de la Comunicación', 'Detrás de una cámara o campaña viral hay mil entregas contra reloj y mucha competencia. Pregúntame qué rama paga mejor entre medios, digital y comunicación corporativa.'),
    ('a1111111-1111-4111-8111-000000000012', 'Contabilidad', 'Diego Cáceres', 5, 'Egresado de Contabilidad', 'Tiene fama de aburrida, pero nunca te falta chamba y en cierres de mes la adrenalina es real. Pregúntame sobre horarios, sueldos junior y cómo crecer rápido en finanzas.'),
    ('a1111111-1111-4111-8111-000000000013', 'Administración de Empresas', 'Paula Mendoza', 4, 'Egresada de Administración de Empresas', 'Como es una carrera súper amplia, el secreto es elegir tu nicho rápido para no quedarte en lo genérico. Pregúntame cómo destacar en prácticas y conseguir tu primer buen sueldo.'),
    ('a1111111-1111-4111-8111-000000000014', 'Marketing', 'Nicolás Reyes', 3, 'Egresado de Marketing', 'Marketing hoy es mitad creatividad y mitad analizar métricas duras en Excel y plataformas digitales. Pregúntame cómo es trabajar en agencia vs. marca y qué piden al egresar.'),
    ('a1111111-1111-4111-8111-000000000015', 'Biología', 'Elena Castillo', 4, 'Egresada de Biología', 'Entre laboratorio, microscopios y salidas de campo te enamoras de la ciencia, aunque financiar proyectos exige paciencia. Pregúntame sobre salidas reales en Perú y fuera.'),
    ('a1111111-1111-4111-8111-000000000016', 'Bioingeniería', 'Joaquín Silva', 3, 'Egresado de Bioingeniería', 'Mezclamos ingeniería dura con salud y tecnología médica: suena futurista y los primeros ciclos son intensos. Pregúntame dónde se trabaja realmente al salir de la uni.'),
    ('a1111111-1111-4111-8111-000000000017', 'Química', 'Fernanda Vargas', 4, 'Egresada de Química', 'Pasas horas en laboratorio cuidando cada detalle y entendiendo de qué está hecho todo. Pregúntame sobre industria, investigación y cómo sobrevivir a Química Orgánica.'),
    ('a1111111-1111-4111-8111-000000000018', 'Física', 'Tomás Aguilar', 4, 'Egresado de Física', 'Te rompe la cabeza con demostraciones, pero te da un súper poder para modelar datos, finanzas o ciencia. Pregúntame qué tan difícil es y en qué terminamos trabajando.'),
    ('a1111111-1111-4111-8111-000000000019', 'Matemáticas', 'Alejandro León', 4, 'Egresado de Matemáticas', 'No es solo ser profe: hoy los bancos, tech y equipos de IA buscan matemáticos puros. Pregúntame cómo fue el salto del colegio a la universidad y las salidas reales.'),
    ('a1111111-1111-4111-8111-000000000020', 'Ingeniería de Software', 'Martina Campos', 4, 'Egresada de Ingeniería de Software', 'Programar es solo una parte; lo retador es diseñar sistemas en equipo y no quemarte con entregas. Pregúntame sobre trabajo remoto, sueldos junior y si importa el portafolio.'),
    ('a1111111-1111-4111-8111-000000000021', 'Ingeniería de Sistemas', 'Mateo Rojas', 4, 'Egresado de Ingeniería de Sistemas', 'Nadie te cuenta que el primer año da vértigo, pero ver tu primer sistema real funcionando lo vale todo. Pregúntame sobre sueldos, cursos difíciles o vida laboral sin filtro.'),
    ('a1111111-1111-4111-8111-000000000022', 'Ingeniería de Ciberseguridad', 'Bruno Torres', 3, 'Egresado de Ingeniería de Ciberseguridad', 'No es como las películas de hackers: es mucha disciplina, redes, presión cuando cae una alerta y aprender cada semana. Pregúntame cómo empezar desde cero y cuánto se gana.'),
    ('a1111111-1111-4111-8111-000000000023', 'Ingeniería Química', 'Carla Espinoza', 5, 'Egresada de Ingeniería Química', 'Más que tubos de ensayo, diseñamos procesos enormes en plantas industriales con mucha física y cálculo. Pregúntame cómo son las prácticas en planta y el ritmo de vida.'),
    ('a1111111-1111-4111-8111-000000000024', 'Ingeniería Ambiental', 'Isabella Ríos', 4, 'Egresada de Ingeniería Ambiental', 'Si quieres cuidar el planeta pero también enfrentarte a normativa, minería o empresas reales, esta es la posta. Pregúntame cómo equilibramos impacto ambiental y trabajo.'),
    ('a1111111-1111-4111-8111-000000000025', 'Ingeniería Electrónica', 'Lucas Medina', 4, 'Egresado de Ingeniería Electrónica', 'Quemar un circuito en el laboratorio es rito de paso, y cálculo te pone a prueba. Pregúntame dónde trabajamos entre automatización, hardware y telecomunicaciones.'),
    ('a1111111-1111-4111-8111-000000000026', 'Ingeniería Mecatrónica', 'Emilio Cruz', 4, 'Egresado de Ingeniería Mecatrónica', 'Juntas mecánica, electrónica y código: te vuelves súper versátil, aunque al inicio parece que nunca terminas de estudiar. Pregúntame si realmente se hacen robots en el trabajo.'),
    ('a1111111-1111-4111-8111-000000000027', 'Ingeniería Mecánica', 'Héctor Ponce', 5, 'Egresado de Ingeniería Mecánica', 'Si te gusta entender cómo funciona cada máquina y no te asustan física ni diseño CAD, aquí hay demanda sólida. Pregúntame sobre planta, oficina y primeros sueldos.'),
    ('a1111111-1111-4111-8111-000000000028', 'Ingeniería Industrial', 'Andrea Chávez', 4, 'Egresada de Ingeniería Industrial', 'Es la navaja suiza de las ingenierías: te abre puertas en logística, datos, operaciones o banca. Pregúntame cómo elegir tu especialidad y no perderte entre tantas opciones.'),
    ('a1111111-1111-4111-8111-000000000029', 'Ingeniería Empresarial', 'Mauricio Flores', 4, 'Egresado de Ingeniería Empresarial', 'Vivimos en el puente entre tecnología y negocio: traducimos problemas de empresa en soluciones con datos. Pregúntame en qué se diferencia de Administración o Industrial.'),
    ('a1111111-1111-4111-8111-000000000030', 'Ingeniería Metalúrgica', 'Fabián Ortiz', 5, 'Egresado de Ingeniería Metalúrgica', 'Muchos ni saben qué hacemos, pero estamos detrás de la minería y materiales clave del país con muy buenos sueldos. Pregúntame cómo es trabajar en campamento y rotación.'),
    ('a1111111-1111-4111-8111-000000000031', 'Ingeniería de Industrias Alimentarias', 'Natalia Ramos', 4, 'Egresada de Ingeniería de Industrias Alimentarias', 'No es cocina: aseguramos que millones de productos sean seguros, ricos y duren en el súper. Pregúntame cómo es el día a día en planta, calidad e innovación de alimentos.'),
    ('a1111111-1111-4111-8111-000000000032', 'Arquitectura', 'Valentina Gálvez', 4, 'Egresada de Arquitectura', 'Las amanecidas haciendo maquetas y planos son reales, pero ver construido un espacio que diseñaste te vuela la cabeza. Pregúntame por costos de la carrera y primeros trabajos.'),
    ('a1111111-1111-4111-8111-000000000033', 'Ingeniería Civil', 'Esteban Morales', 5, 'Egresado de Ingeniería Civil', 'Te toca sol, casco, obra y también oficina calculando estructuras para que nada falle. Pregúntame cómo es mandar en obra siendo joven y qué tan bien se paga al iniciar.'),
    ('a1111111-1111-4111-8111-000000000034', 'Agronomía', 'Álvaro Núñez', 4, 'Egresado de Agronomía', 'La agroindustria moderna usa drones, sensores y ciencia real, pero también implica madrugar y viajar a campo. Pregúntame cómo es la vida fuera de oficina y su demanda.'),
    ('a1111111-1111-4111-8111-000000000035', 'Medicina Veterinaria', 'Julieta Morales', 4, 'Egresada de Medicina Veterinaria', 'Amar a los animales te impulsa, pero también toca lidiar con dueños difíciles y momentos muy duros en clínica. Pregúntame la verdad sobre guardias, especialidad e ingresos.'),
    ('a1111111-1111-4111-8111-000000000036', 'Odontología', 'Gonzalo Peña', 4, 'Egresado de Odontología', 'Es una carrera muy manual y costosa en materiales durante la uni, pero te permite independizarte rápido. Pregúntame cuánto cuesta estudiarla y cómo conseguir pacientes.'),
    ('a1111111-1111-4111-8111-000000000037', 'Medicina Humana', 'Santiago Cruz', 4, 'Egresado de Medicina Humana', 'Son años largos, guardias agotadoras y sacrificar varias salidas, pero salvar o aliviar a alguien no se compara con nada. Pregúntame sin filtro si vale la pena el esfuerzo.'),
    ('a1111111-1111-4111-8111-000000000038', 'Enfermería', 'Milagros Díaz', 4, 'Egresada de Enfermería', 'Somos el corazón del hospital y casi nunca falta trabajo, incluso para migrar al extranjero, aunque los turnos rotativos pesan. Pregúntame cómo se maneja el desgaste.'),
    ('a1111111-1111-4111-8111-000000000039', 'Tecnología Médica', 'Cristian Vera', 4, 'Egresado de Tecnología Médica', 'Desde laboratorio clínico hasta radiología o terapia física: haces salud de alto impacto sin estudiar 7 años de medicina. Pregúntame cuál mención tiene más demanda hoy.'),
    ('a1111111-1111-4111-8111-000000000040', 'Farmacia y Bioquímica', 'Claudia Romero', 4, 'Egresada de Farmacia y Bioquímica', 'No es solo atender una botica: estamos en laboratorios farmacéuticos, toxicología y análisis clínico. Pregúntame qué tan exigente es la química y cuánto se gana al inicio.'),
    ('a1111111-1111-4111-8111-000000000041', 'Hotelería y Turismo', 'Alejandra Soto', 3, 'Egresada de Hotelería y Turismo', 'Conoces gente de todo el mundo y puedes trabajar viajando, pero prepárate para trabajar feriados y fines de semana. Pregúntame cómo crecer rápido con idiomas.'),
    ('a1111111-1111-4111-8111-000000000042', 'Gastronomía y Arte Culinario', 'Braulio Sánchez', 4, 'Egresado de Gastronomía y Arte Culinario', 'En cocina real hace calor, estás de pie horas y la presión en servicio es brutal, nada que ver con los reels. Pregúntame cómo empezar, sueldos y cómo emprender.'),
    ('a1111111-1111-4111-8111-000000000043', 'Pastelería y Panaderia', 'Bianca Lozano', 3, 'Egresada de Pastelería y Panaderia', 'Aquí todo es precisión química, madrugadas y mucha práctica hasta que la masa salga perfecta. Pregúntame si conviene trabajar en hoteles o lanzar tu propia marca.'),
    ('a1111111-1111-4111-8111-000000000044', 'Bar y Coctelería', 'Ignacio Bravo', 3, 'Egresado de Bar y Coctelería', 'Combinas sabores, hospitalidad y show bajo presión nocturna, con buenas opciones en hoteles y cruceros. Pregúntame cómo es el horario real y cómo profesionalizarte.'),
    ('a1111111-1111-4111-8111-000000000045', 'Derecho', 'Luciana Pacheco', 4, 'Egresada de Derecho', 'Se lee muchísimo y las prácticas en estudios pueden ser intensas, pero defender un caso o cerrar un acuerdo te engancha. Pregúntame cómo destacar sin tener apellido famoso.'),
    ('a1111111-1111-4111-8111-000000000046', 'Obstetricia', 'Fiorella Meza', 4, 'Egresada de Obstetricia', 'Acompañar el nacimiento de una vida emociona siempre, pero exige nervios de acero en emergencias y guardias nocturnas. Pregúntame sobre el internado y el campo laboral.'),
    ('a1111111-1111-4111-8111-000000000047', 'Nutrición Humana y Dietética', 'Ariana Cordero', 3, 'Egresada de Nutrición Humana y Dietética', 'Mucho más que hacer dietas para bajar de peso: vemos clínica, deporte e industria alimentaria con base científica fuerte. Pregúntame cómo conseguir tus primeros pacientes.'),
    ('a1111111-1111-4111-8111-000000000048', 'Trabajo Social', 'Karla Mendoza', 4, 'Egresada de Trabajo Social', 'Trabajas directo con realidades humanas en empresas, colegios y programas sociales; necesitas empatía pero también límites claros. Pregúntame dónde hay más chamba.'),
    ('a1111111-1111-4111-8111-000000000049', 'Zootecnia', 'Rafael Gómez', 4, 'Egresado de Zootecnia', 'Nos enfocamos en producción animal sostenible, genética y nutrición en granjas y campo abierto. Pregúntame en qué se diferencia de Veterinaria y cómo es la vida laboral.'),
    ('a1111111-1111-4111-8111-000000000050', 'Ingeniería de Minas', 'Renzo Alarcón', 5, 'Egresado de Ingeniería de Minas', 'Los sueldos de entrada son de los más altos, pero trabajar bajo régimen en altura lejos de casa no es para cualquiera. Pregúntame sin filtro cómo se lleva la vida personal.'),
    ('a1111111-1111-4111-8111-000000000051', 'Ingeniería Eléctrica', 'Óscar Valverde', 5, 'Egresado de Ingeniería Eléctrica', 'Trabajamos con alta tensión, energías renovables y que una ciudad entera no se quede sin luz. Los cursos son exigentes, pero la empleabilidad es altísima. Pregúntame.'),
    ('a1111111-1111-4111-8111-000000000052', 'Ingeniería Geológica', 'Piero Quiroz', 4, 'Egresado de Ingeniería Geológica', 'Si no te ves encerrado en una oficina 8 horas, aquí exploras montañas, rocas y riesgos naturales con buena paga en minería y energía. Pregúntame cómo es el trabajo en campo.'),
    ('a1111111-1111-4111-8111-000000000053', 'Ingeniería Agrícola', 'Marco Palacios', 4, 'Egresado de Ingeniería Agrícola', 'Diseñamos riego tecnificado, maquinaria y obras rurales para que el campo produzca mejor cuidando el agua. Pregúntame qué hacemos en el día a día y dónde contratan.'),
    ('a1111111-1111-4111-8111-000000000054', 'Ingeniería Forestal', 'Ximena Ibarra', 4, 'Egresada de Ingeniería Forestal', 'Entre selva, conservación, bonos de carbono e industria sostenible, pasas bastante tiempo en campo real. Pregúntame sobre el equilibrio entre cuidar bosques y trabajar.'),
    ('a1111111-1111-4111-8111-000000000055', 'Ingeniería Pesquera', 'Víctor Luján', 4, 'Egresado de Ingeniería Pesquera', 'En un país con mar tan rico, trabajamos en acuicultura, plantas marinas y sostenibilidad con poca competencia. Pregúntame cómo es vivir cerca de puertos y los ingresos.'),
    ('a1111111-1111-4111-8111-000000000056', 'Ingeniería Sanitaria', 'Adriana Beltrán', 4, 'Egresada de Ingeniería Sanitaria', 'Pocas personas conocen esta carrera, pero aseguramos agua potable y tratamiento ambiental en ciudades enteras, con gran demanda. Pregúntame cómo es el trabajo real.'),
    ('a1111111-1111-4111-8111-000000000057', 'Ingeniería Textil', 'Giselle Montoya', 4, 'Egresada de Ingeniería Textil', 'Detrás de la moda exportadora estamos nosotros viendo fibras, maquinaria, calidad y sostenibilidad en fábrica. Pregúntame en qué se diferencia de Diseño de Modas.'),
    ('a1111111-1111-4111-8111-000000000058', 'Ingeniería Naval', 'César Maldonado', 5, 'Egresado de Ingeniería Naval', 'Diseñar y mantener embarcaciones es un nicho chico pero súper técnico y bien valorado en astilleros y puertos. Pregúntame cómo son los cursos y el mercado laboral.'),
    ('a1111111-1111-4111-8111-000000000059', 'Ingeniería de Telecomunicaciones', 'Kevin Miranda', 4, 'Egresado de Ingeniería de Telecomunicaciones', 'Sin nosotros no habría 5G, fibra óptica ni nube funcionando. Tiene física dura al inicio, pero luego el mundo tech y redes te abre puertas rápido. Pregúntame sin filtro.'),
    ('a1111111-1111-4111-8111-000000000060', 'Arqueología', 'Paloma Quispe', 4, 'Egresada de Arqueología', 'No es Indiana Jones: es excavar bajo el sol con mucha paciencia, ciencia y papeleo de patrimonio, pero descubrir historia real engancha. Pregúntame de qué vivimos.'),
    ('a1111111-1111-4111-8111-000000000061', 'Antropología', 'Ernesto Tapia', 4, 'Egresado de Antropología', 'Entendemos culturas y comunidades desde adentro; hoy trabajamos tanto en investigación social como en UX Research para empresas tech. Pregúntame cómo abrirte camino.'),
    ('a1111111-1111-4111-8111-000000000062', 'Filosofía', 'Inés Villalobos', 4, 'Egresada de Filosofía', 'Te entrena la mente para argumentar y cuestionarlo todo; hoy muchos terminamos en ética de IA, edición, docencia o consultoría. Pregúntame la verdad sobre la empleabilidad.'),
    ('a1111111-1111-4111-8111-000000000063', 'Estadística', 'Dante Guerrero', 4, 'Egresado de Estadística', 'Antes pocos la elegían y hoy casi todas las empresas se pelean por perfiles de datos y modelos predictivos. Pregúntame por los cursos de mate, programación y sueldos.'),
    ('a1111111-1111-4111-8111-000000000064', 'Ciencias de la Computación', 'Diana Flores', 3, 'Egresada de Ciencias de la Computación', 'Vamos más profundo en algoritmos, matemáticas e IA que solo hacer apps; exige estudio duro pero te prepara para competir globalmente. Pregúntame cómo es el salto laboral.'),
    ('a1111111-1111-4111-8111-000000000065', 'Música', 'Jairo Escobedo', 4, 'Egresado de Música', 'Vivir de la música exige disciplina diaria, aprender producción o docencia y quitarte el mito de "solo talento". Pregúntame sin filtro cómo se generan ingresos reales.'),
    ('a1111111-1111-4111-8111-000000000066', 'Ingeniería de Inteligencia Artificial', 'Samuel Paredes', 3, 'Egresado de Ingeniería de Inteligencia Artificial', 'No es escribir prompts: es matemática pesada, datos sucios y código para entrenar modelos que funcionen en el mundo real. Pregúntame qué piden hoy y cuánto se gana.'),
    ('a1111111-1111-4111-8111-000000000067', 'Mecatrónica Automotriz', 'Bryan Huamán', 4, 'Egresado de Mecatrónica Automotriz', 'Los autos de hoy son computadoras con ruedas: mezclamos electrónica, diagnóstico digital y taller práctico con salida laboral rápida. Pregúntame cuánto se gana al empezar.'),
    ('a1111111-1111-4111-8111-000000000068', 'Mantenimiento de Maquinaria Pesada', 'Luis Ángel Castro', 4, 'Egresado de Mantenimiento de Maquinaria Pesada', 'Trabajas con equipos gigantes en minería y construcción; es exigente físicamente y con turnos en campo, pero paga muy bien desde joven. Pregúntame cómo entrar al rubro.'),
    ('a1111111-1111-4111-8111-000000000069', 'Diseño y Gestión de Modas', 'Abril Santamaría', 3, 'Egresada de Diseño y Gestión de Modas', 'Hay creatividad y pasarela, pero el 80% del éxito está en telas, costos, talleres y saber vender tu marca. Pregúntame cómo empezar en industria o emprender sin quebrar.'),
    ('a1111111-1111-4111-8111-000000000070', 'Administración Bancaria y Financiera', 'Sergio Cárdenas', 4, 'Egresado de Administración Bancaria y Financiera', 'Es súper práctica y entras rápido a bancos o fintech, aunque trabajar con metas comerciales tiene su presión. Pregúntame cómo es el primer año y cómo escalar sueldos.'),
    ('a1111111-1111-4111-8111-000000000071', 'Finanzas', 'Raúl Becerra', 4, 'Egresado de Finanzas', 'Analizas inversiones, riesgo y valor de empresas con bastante Excel y presión por resultados, pero con proyección muy alta. Pregúntame por jornadas, prácticas y sueldos reales.')
) AS v(id, career_name, mentor_name, years_of_experience, specialty, bio)
JOIN careers c
    ON LOWER(TRIM(c.name)) = LOWER(TRIM(v.career_name))
WHERE NOT EXISTS (
    SELECT 1
    FROM career_mentor_archetypes existing
    WHERE existing.career_id = c.id
      AND existing.is_active = TRUE
      AND existing.id <> v.id::uuid
)
ON CONFLICT (id) DO UPDATE SET
    mentor_name = EXCLUDED.mentor_name,
    years_of_experience = EXCLUDED.years_of_experience,
    specialty = EXCLUDED.specialty,
    bio = EXCLUDED.bio,
    is_active = TRUE;

--rollback DELETE FROM career_mentor_archetypes WHERE id::text LIKE 'a1111111-1111-4111-8111-0000000000%';
