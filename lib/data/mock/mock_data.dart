import '../models/student.dart';
import '../models/modality.dart';
import '../models/university.dart';
import '../models/chat_preview.dart';
import '../models/conversation_message.dart';
import '../models/notification_item.dart';

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
    bio: 'Estudio Matemáticas Aplicadas, me interesa la filosofía de la mente y la teoría de categorías. Café, libros y caminatas largas.',
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

  static const universities = [
    University(name: 'Anáhuac Oaxaca', emailDomain: '@anahuac.mx', verified: true),
    University(name: 'Tec Monterrey Oaxaca', emailDomain: '@tec.mx', verified: false),
    University(name: 'La Salle Oaxaca', emailDomain: '@lasalle.mx', verified: false),
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
      bio: 'Apasionada del marketing digital y las redes sociales. Busco compañeros para estudiar y hacer proyectos creativos.',
      interests: ['Marketing digital', 'Fotografía', 'Diseño', 'Podcasts', 'Redes sociales'],
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
      bio: 'Matemático en formación. Me gusta la teoría de grafos y los problemas de optimización. Siempre listo para un café de estudio.',
      interests: ['Teoría de grafos', 'Programación', 'Ajedrez', 'Filosofía', 'Café'],
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
      bio: 'Estudiante de psicología con enfoque en neurociencia cognitiva. Me encanta explorar la ciudad y descubrir lugares nuevos.',
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
      bio: 'Arquitecto en construcción. Me inspiro en el diseño bioclimático y la arquitectura vernácula oaxaqueña.',
      interests: ['Diseño bioclimático', 'Fotografía urbana', 'Senderismo', 'Gastronomía', 'Música'],
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
      bio: 'Estudiante de derecho enfocada en derechos humanos y justicia social. Activista, lectora compulsiva y amante del café.',
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
      bio: 'Desarrollador en formación. Especializado en apps móviles y machine learning. Busco equipo para hackathons.',
      interests: ['Machine learning', 'Apps móviles', 'Videojuegos', 'Manga', 'Hackathons'],
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
      bio: 'Diseñadora gráfica apasionada por la identidad visual y el branding. Siempre con bocetos en la mano.',
      interests: ['Branding', 'Ilustración', 'Tipografía', 'Música indie', 'Viajes'],
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
      text: 'Hola Sofía, vi que también estudias Matemáticas Aplicadas. ¿En qué semestre estás?',
      isMe: false,
      time: '10:30',
    ),
    ConversationMessage(
      id: 'm2',
      text: 'Hola Diego! Sí, estoy en quinto. ¿Tú también? Qué coincidencia, jaja',
      isMe: true,
      time: '10:33',
    ),
    ConversationMessage(
      id: 'm3',
      text: 'Exacto, quinto semestre. Tengo Álgebra Lineal con el profesor Mendoza y me está costando trabajo. ¿Lo conoces?',
      isMe: false,
      time: '10:35',
    ),
    ConversationMessage(
      id: 'm4',
      text: 'Sí! Yo ya tomé esa clase. Es densa pero interesante. Si quieres podemos estudiar juntos, tengo buenos apuntes.',
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
}
