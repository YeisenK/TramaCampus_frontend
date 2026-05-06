import '../models/affiliate_business.dart';
import '../models/chat_preview.dart';
import '../models/conversation_message.dart';
import '../models/group.dart';
import '../models/marketplace_listing.dart';
import '../models/modality.dart';
import '../models/notification_item.dart';
import '../models/profile/preferences.dart';
import '../models/profile/profile.dart';
import '../models/profile/profile_attribute.dart';
import '../models/profile/profile_base.dart';
import '../models/student.dart';
import '../models/task.dart';
import '../models/university.dart';

class MockData {
  MockData._();

  static const currentUser = Student(
    id: 'sofia',
    name: 'Sofía Ramírez',
    age: 21,
    program: 'Matemáticas Aplicadas',
    semester: 5,
    hue: 24,
    intent: ModalityType.estudio,
    photoUrl: 'assets/images/avatars/sofia.jpg',
    bio:
        'Estudio Matemáticas Aplicadas, me interesa la filosofía de la mente y la teoría de categorías. Café, libros y caminatas largas.',
    interests: [
      'Filosofía de la mente',
      'Topología',
      'Investigación cualitativa',
      'Café de especialidad',
      'Cine de autor',
      'Senderismo',
    ],
    compatibilityScore: 100,
  );

  // Structured Profile representation of currentUser — backend-compatible.
  static final currentProfile = Profile(
    base: const ProfileBase(
      displayName: 'Sofía Ramírez',
      firstName: 'Sofía',
      lastName: 'Ramírez',
      bio: 'Estudio Ingeniería en Tecnologías de la Información, me apasionan los datos, la IA y el desarrollo de software.',
      careerId: 'BITDB',
      semester: 5,
      universityId: '0001',
      gender: 'F',
      genderPreference: 'any',
    ),
    preferences: const Preferences(
      modes: ['study', 'research', 'competition'],
      uiModality: 'estudio',
      goals: ['study partner', 'research collaborator'],
      skills: ['python', 'data analysis', 'academic writing'],
      connectivityState: 'active',
    ),
    attributes: const [
      HobbyAttribute(hobbyId: 'hiking'),
      HobbyAttribute(hobbyId: 'photography'),
      PersonalityAttribute(traitId: 'curioso'),
      PersonalityAttribute(traitId: 'analítico'),
      MusicAttribute(genreId: 'folk'),
      MusicAttribute(genreId: 'indie'),
    ],
  );

  static const universities = [
    University(
      name: 'Anáhuac Oaxaca',
      emailDomain: '@anahuac.mx',
      verified: true,
    ),
    University(
      name: 'Tec Monterrey Oaxaca',
      emailDomain: '@tec.mx',
      verified: false,
    ),
    University(
      name: 'La Salle Oaxaca',
      emailDomain: '@lasalle.mx',
      verified: false,
    ),
    University(name: 'UABJO Oaxaca', emailDomain: '@uabjo.mx', verified: false),
  ];

  static const students = [
    Student(
      id: 'ana',
      name: 'Ana Gómez',
      age: 20,
      program: 'Mercadotecnia',
      semester: 5,
      hue: 20,
      intent: ModalityType.estudio,
      photoUrl: 'assets/images/avatars/ana.jpg',
      bio:
          'Apasionada del marketing digital y las redes sociales. Busco compañeros para estudiar y hacer proyectos creativos.',
      interests: [
        'Marketing digital',
        'Fotografía',
        'Diseño',
        'Podcasts',
        'Redes sociales',
      ],
      compatibilityScore: 87,
      reasons: ['Mismo semestre', 'Área afín', 'Horario compatible'],
    ),
    Student(
      id: 'diego',
      name: 'Diego Navarro',
      age: 21,
      program: 'Matemáticas Aplicadas',
      semester: 5,
      hue: 240,
      intent: ModalityType.estudio,
      photoUrl: 'assets/images/avatars/diego.jpg',
      bio:
          'Matemático en formación. Me gusta la teoría de grafos y los problemas de optimización. Siempre listo para un café de estudio.',
      interests: [
        'Teoría de grafos',
        'Programación',
        'Ajedrez',
        'Filosofía',
        'Café',
      ],
      compatibilityScore: 94,
      reasons: ['Mismo programa', 'Mismo semestre', 'Intereses en común'],
    ),
    Student(
      id: 'renata',
      name: 'Renata Fuentes',
      age: 22,
      program: 'Psicología',
      semester: 7,
      hue: 320,
      intent: ModalityType.amistad,
      photoUrl: 'assets/images/avatars/renata.jpg',
      bio:
          'Estudiante de psicología con enfoque en neurociencia cognitiva. Me encanta explorar la ciudad y descubrir lugares nuevos.',
      interests: ['Neurociencia', 'Meditación', 'Cine', 'Arte urbano', 'Yoga'],
      compatibilityScore: 78,
      reasons: ['Intereses complementarios', 'Disponible fines de semana'],
    ),
    Student(
      id: 'mateo',
      name: 'Mateo Álvarez',
      age: 21,
      program: 'Arquitectura',
      semester: 5,
      hue: 180,
      intent: ModalityType.amistad,
      photoUrl: 'assets/images/avatars/mateo.jpg',
      bio:
          'Arquitecto en construcción. Me inspiro en el diseño bioclimático y la arquitectura vernácula oaxaqueña.',
      interests: [
        'Diseño bioclimático',
        'Fotografía urbana',
        'Senderismo',
        'Gastronomía',
        'Música',
      ],
      compatibilityScore: 82,
      reasons: ['Mismo semestre', 'Le gusta el senderismo'],
    ),
    Student(
      id: 'lucia',
      name: 'Lucía Herrera',
      age: 19,
      program: 'Derecho',
      semester: 3,
      hue: 120,
      intent: ModalityType.personal,
      photoUrl: 'assets/images/avatars/lucia.jpg',
      bio:
          'Estudiante de derecho enfocada en derechos humanos y justicia social. Activista, lectora compulsiva y amante del café.',
      interests: ['Derechos humanos', 'Lectura', 'Activismo', 'Teatro', 'Café'],
      compatibilityScore: 71,
      reasons: ['Valores compartidos', 'Ama el café'],
    ),
    Student(
      id: 'javier',
      name: 'Javier Cortés',
      age: 22,
      program: 'Ing. Software',
      semester: 5,
      hue: 60,
      intent: ModalityType.estudio,
      photoUrl: 'assets/images/avatars/javier.jpg',
      bio:
          'Desarrollador en formación. Especializado en apps móviles y machine learning. Busco equipo para hackathons.',
      interests: [
        'Machine learning',
        'Apps móviles',
        'Videojuegos',
        'Manga',
        'Hackathons',
      ],
      compatibilityScore: 85,
      reasons: ['Mismo semestre', 'Área STEM', 'Hackathons'],
    ),
    Student(
      id: 'camila',
      name: 'Camila Ruíz',
      age: 20,
      program: 'Diseño Gráfico',
      semester: 5,
      hue: 340,
      intent: ModalityType.amistad,
      photoUrl: 'assets/images/avatars/camila.jpg',
      bio:
          'Diseñadora gráfica apasionada por la identidad visual y el branding. Siempre con bocetos en la mano.',
      interests: [
        'Branding',
        'Ilustración',
        'Tipografía',
        'Música indie',
        'Viajes',
      ],
      compatibilityScore: 76,
      reasons: ['Mismo semestre', 'Área creativa'],
    ),
  ];

  static const chats = [
    ChatPreview(
      studentId: 'diego',
      studentName: 'Diego Navarro',
      hue: 240,
      lastMessage: '¿Estudiamos en la biblioteca mañana?',
      time: '10:42',
      unreadCount: 2,
    ),
    ChatPreview(
      studentId: 'ana',
      studentName: 'Ana Gómez',
      hue: 20,
      lastMessage: 'Perfecto, nos vemos el jueves',
      time: 'Ayer',
      unreadCount: 0,
    ),
    ChatPreview(
      studentId: 'renata',
      studentName: 'Renata Fuentes',
      hue: 320,
      lastMessage: 'Me pasas el apunte cuando puedas',
      time: 'Lun',
      unreadCount: 0,
    ),
    ChatPreview(
      studentId: 'mateo',
      studentName: 'Mateo Álvarez',
      hue: 180,
      lastMessage: 'El senderismo fue increíble 🏔️',
      time: 'Dom',
      unreadCount: 1,
    ),
    ChatPreview(
      studentId: 'javier',
      studentName: 'Javier Cortés',
      hue: 60,
      lastMessage: '¿Tienes el repo de GitHub?',
      time: 'Sab',
      unreadCount: 0,
    ),
  ];

  static const conversation = [
    ConversationMessage(
      id: 'm1',
      text:
          'Hola Sofía, vi que también estudias Matemáticas Aplicadas. ¿En qué semestre estás?',
      isMe: false,
      time: '10:30',
    ),
    ConversationMessage(
      id: 'm2',
      text:
          'Hola Diego! Sí, estoy en quinto. ¿Tú también? Qué coincidencia, jaja',
      isMe: true,
      time: '10:33',
    ),
    ConversationMessage(
      id: 'm3',
      text:
          'Exacto, quinto semestre. Tengo Álgebra Lineal con el profesor Mendoza y me está costando trabajo. ¿Lo conoces?',
      isMe: false,
      time: '10:35',
    ),
    ConversationMessage(
      id: 'm4',
      text:
          'Sí! Yo ya tomé esa clase. Es densa pero interesante. Si quieres podemos estudiar juntos, tengo buenos apuntes.',
      isMe: true,
      time: '10:38',
    ),
    ConversationMessage(
      id: 'm5',
      text: '¿Estudiamos en la biblioteca mañana?',
      isMe: false,
      time: '10:42',
    ),
  ];

  static final List<AffiliateBusiness> mockAffiliateBusinesses = [
    const AffiliateBusiness(
      id: 'biz1',
      name: 'Café El Origen',
      description:
          'Cafetería universitaria con desayunos, comida rápida y bebidas de especialidad. Abierto de 7am a 9pm de lunes a sábado.',
      serviceType: AffiliateServiceType.restaurant,
      isVerified: true,
      menuPdfUrl: 'https://tramacampus.mx/menus/el-origen.pdf',
      promotions: [
        '10% descuento con credencial Anáhuac',
        'Café del día a \$20 en desayunos',
      ],
      acceptsReservations: true,
      acceptsOrders: true,
      contactChannel: '/conversation',
    ),
    const AffiliateBusiness(
      id: 'biz2',
      name: 'FitCampus Gym',
      description:
          'Gimnasio universitario con equipos modernos, clases de yoga, spinning y crossfit. Membresías mensuales y por clase.',
      serviceType: AffiliateServiceType.gym,
      isVerified: true,
      promotions: ['Primera clase gratis', 'Membresía semestral con 20% off'],
      acceptsReservations: true,
      acceptsOrders: false,
      contactChannel: '/conversation',
    ),
    const AffiliateBusiness(
      id: 'biz3',
      name: 'CopyRápido',
      description:
          'Copistería y papelería frente al campus. Impresión, engargolado, papel bond y más. Pedidos por encargo.',
      serviceType: AffiliateServiceType.copyshop,
      isVerified: true,
      promotions: ['Engargolado gratis en pedidos +100 hojas'],
      acceptsReservations: false,
      acceptsOrders: true,
      contactChannel: '/conversation',
    ),
    const AffiliateBusiness(
      id: 'biz4',
      name: 'Trama Design Studio',
      description:
          'Marca patrocinadora oficial de TramaCampus. Descuentos exclusivos en software creativo y equipos para estudiantes.',
      serviceType: AffiliateServiceType.brand,
      isVerified: true,
      promotions: [
        '30% off en Adobe Creative Cloud',
        'Licencias estudiantiles a precio especial',
      ],
      acceptsReservations: false,
      acceptsOrders: false,
      contactChannel: '/conversation',
    ),
  ];

  static final List<MarketplaceListing> mockListings = [
    MarketplaceListing(
      id: 'lst1',
      title: 'Apuntes completos Cálculo II',
      description:
          'Apuntes digitales completos del semestre de Cálculo II con el prof. Mendoza. Incluye ejercicios resueltos y resúmenes por unidad.',
      price: 80,
      category: ListingCategory.apuntes,
      type: ListingType.studentListing,
      isBoosted: true,
      isAffiliate: false,
      sellerName: 'Diego Navarro',
      imageUrls: [
        'https://picsum.photos/seed/calculo1/400/300',
        'https://picsum.photos/seed/calculo2/400/300',
      ],
      publishedAt: DateTime(2025, 4, 28),
    ),
    MarketplaceListing(
      id: 'lst2',
      title: 'Diseño de logo profesional',
      description:
          'Diseño de identidad visual para emprendedores o proyectos estudiantiles. Incluye 3 propuestas, ajustes ilimitados y entrega en SVG/PNG.',
      price: 350,
      category: ListingCategory.freelance,
      type: ListingType.studentListing,
      isBoosted: true,
      isAffiliate: false,
      sellerName: 'Camila Ruíz',
      imageUrls: [
        'https://picsum.photos/seed/design1/400/300',
        'https://picsum.photos/seed/design2/400/300',
        'https://picsum.photos/seed/design3/400/300',
      ],
      publishedAt: DateTime(2025, 4, 27),
    ),
    MarketplaceListing(
      id: 'lst3',
      title: 'Tutoría de Álgebra Lineal',
      description:
          'Sesiones de tutoría privada 1 a 1 para Álgebra Lineal y Cálculo. Presencial o por videollamada. Disponible para semestres 3–5.',
      price: 120,
      category: ListingCategory.servicios,
      type: ListingType.studentListing,
      isBoosted: false,
      isAffiliate: false,
      sellerName: 'Diego Navarro',
      imageUrls: ['https://picsum.photos/seed/tutoria1/400/300'],
      publishedAt: DateTime(2025, 4, 25),
    ),
    MarketplaceListing(
      id: 'lst4',
      title: 'Calculadora Casio fx-991 de segunda mano',
      description:
          'Calculadora científica en excelentes condiciones. Sin rayones. Incluye estuche original. Perfecta para Ingeniería o Ciencias.',
      price: 200,
      category: ListingCategory.articulos,
      type: ListingType.studentListing,
      isBoosted: false,
      isAffiliate: false,
      sellerName: 'Javier Cortés',
      imageUrls: [
        'https://picsum.photos/seed/calc1/400/300',
        'https://picsum.photos/seed/calc2/400/300',
      ],
      publishedAt: DateTime(2025, 4, 23),
    ),
    MarketplaceListing(
      id: 'lst5',
      title: 'Resúmenes de Derecho Civil y Penal',
      description:
          'Apuntes y resúmenes de jurisprudencia y legislación para Derecho Civil y Penal. Semestres 3–6. Formato PDF editable.',
      price: 60,
      category: ListingCategory.apuntes,
      type: ListingType.studentListing,
      isBoosted: false,
      isAffiliate: false,
      sellerName: 'Lucía Herrera',
      imageUrls: ['https://picsum.photos/seed/derecho1/400/300'],
      publishedAt: DateTime(2025, 4, 20),
    ),
    MarketplaceListing(
      id: 'lst6',
      title: 'Sesión fotográfica para portafolio',
      description:
          'Mini sesión fotográfica para portafolio académico o redes sociales. 30 min, 10 fotos editadas entregadas en 48h. Estudio o exterior.',
      price: 450,
      category: ListingCategory.freelance,
      type: ListingType.studentListing,
      isBoosted: false,
      isAffiliate: false,
      sellerName: 'Ana Gómez',
      imageUrls: [
        'https://picsum.photos/seed/foto1/400/300',
        'https://picsum.photos/seed/foto2/400/300',
        'https://picsum.photos/seed/foto3/400/300',
      ],
      publishedAt: DateTime(2025, 4, 18),
    ),
  ];

  static const notifications = [
    NotificationItem(
      id: 'n1',
      type: NotificationType.match,
      title: 'Conectaste con Diego Navarro',
      subtitle: 'Empezá a chatear ahora',
      time: 'Hace 5 min',
      isRead: false,
      hue: 240,
    ),
    NotificationItem(
      id: 'n2',
      type: NotificationType.request,
      title: 'Ana Gómez quiere estudiar contigo',
      subtitle: 'Aceptar o ignorar la solicitud',
      time: 'Hace 1 h',
      isRead: false,
      hue: 20,
    ),
    NotificationItem(
      id: 'n3',
      type: NotificationType.group,
      title: 'Nuevo grupo: Café & Topología',
      subtitle: '3 personas con intereses similares',
      time: 'Ayer',
      isRead: true,
      hue: 180,
    ),
    NotificationItem(
      id: 'n4',
      type: NotificationType.match,
      title: 'Match recíproco con Mateo Álvarez',
      subtitle: 'Tienen mucho en común',
      time: 'Lun',
      isRead: true,
      hue: 180,
    ),
  ];

  static const List<Group> mockGroups = [
    Group(
      id: 'g1',
      name: 'Hackathon Nacional · Equipo C',
      tagline: 'Equipo cerrado · Ing. de Software · entrega 14 nov',
      kind: GroupKind.project,
      access: GroupAccess.invite,
      verified: false,
      featured: true,
      hue: 60,
      memberCount: 4,
      capacity: 5,
      activity: 'Activo · ahora',
      nextAction: 'Sprint hoy 19:00 · Lab Cómputo',
      leader: 'Javier Cortés',
      description:
          'Equipo formado para el Hackathon Nacional 2025. Buscamos un quinto miembro con perfil de UI/UX o frontend.',
    ),
    Group(
      id: 'g2',
      name: 'Filosofía de la mente',
      tagline: 'Lectura y discusión · martes 18:00',
      kind: GroupKind.study,
      access: GroupAccess.open,
      verified: false,
      featured: true,
      hue: 240,
      memberCount: 14,
      capacity: 20,
      activity: 'Activo esta semana',
      nextAction: 'Sesión martes 18:00 · Biblioteca p.3',
      leader: 'Diego Navarro',
      description:
          'Grupo de lectura interdisciplinar. Este semestre: Hofstadter, Dennett y Chalmers.',
    ),
    Group(
      id: 'g3',
      name: 'Trama · Anuncios oficiales',
      tagline: 'Comunicados de la administración del campus',
      kind: GroupKind.official,
      access: GroupAccess.open,
      verified: true,
      featured: false,
      hue: 22,
      memberCount: 2840,
      activity: 'Oficial · solo lectura',
      nextAction: 'Sin acción pendiente',
      leader: 'Anáhuac Oaxaca',
      description:
          'Canal oficial. Solo administradores del campus pueden publicar.',
    ),
    Group(
      id: 'g4',
      name: 'Running Anáhuac',
      tagline: 'Trail y carrera · 3 sesiones / semana',
      kind: GroupKind.sport,
      access: GroupAccess.open,
      verified: false,
      featured: false,
      hue: 120,
      memberCount: 32,
      activity: 'Activo hoy',
      nextAction: 'Quedada sábado 7:00 · Cerro del Fortín',
      leader: 'Mateo Álvarez',
      description:
          'Para corredores de cualquier nivel. Coordinamos quedadas y entrenamos para el maratón de Oaxaca.',
    ),
    Group(
      id: 'g5',
      name: 'Emprendimiento · founders Oaxaca',
      tagline: 'Club universitario · pitch nights mensuales',
      kind: GroupKind.club,
      access: GroupAccess.request,
      verified: true,
      featured: true,
      hue: 200,
      memberCount: 48,
      activity: 'Activo hoy',
      nextAction: 'Pitch night 28 nov',
      leader: 'Comité estudiantil',
      description:
          'Club oficial reconocido por el campus. Conectamos founders estudiantiles con mentores y aceleradoras.',
    ),
  ];

  static const List<String> myGroupIds = ['g1', 'g2', 'g4'];

  static const List<Task> mockGroupTasks = [
    Task(
      id: 't1',
      code: 'HKT-12',
      title: 'Diseñar onboarding de la app',
      status: TaskStatus.inProgress,
      assigneeName: 'Camila R.',
      due: 'Hoy',
      priority: TaskPriority.high,
    ),
    Task(
      id: 't2',
      code: 'HKT-11',
      title: 'Auth con Supabase',
      status: TaskStatus.done,
      assigneeName: 'Javier C.',
      due: 'Ayer',
      priority: TaskPriority.med,
    ),
    Task(
      id: 't3',
      code: 'HKT-13',
      title: 'Pitch deck v2 — slides 6 a 10',
      status: TaskStatus.todo,
      assigneeName: 'Sofía R.',
      due: 'Mañana',
      priority: TaskPriority.high,
    ),
    Task(
      id: 't4',
      code: 'HKT-14',
      title: 'Demo del flujo de matching',
      status: TaskStatus.todo,
      assigneeName: 'Diego N.',
      due: '14 nov',
      priority: TaskPriority.high,
    ),
    Task(
      id: 't5',
      code: 'HKT-10',
      title: 'Setup CI/CD',
      status: TaskStatus.done,
      assigneeName: 'Javier C.',
      due: 'Hace 2 días',
      priority: TaskPriority.low,
    ),
    Task(
      id: 't6',
      code: 'HKT-15',
      title: 'Análisis de competencia',
      status: TaskStatus.todo,
      assigneeName: 'Sofía R.',
      due: '12 nov',
      priority: TaskPriority.med,
    ),
  ];
}
