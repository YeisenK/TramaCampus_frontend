// LEGAL_REVIEW_REQUIRED: Todo el contenido de este archivo debe ser revisado por
// un abogado mexicano especializado en LFPDPPP antes del lanzamiento comercial.
// Ninguna disposición aquí constituye asesoría legal.

import 'package:flutter/material.dart';
import '../../core/constants/app_info.dart';

class LegalSection {
  const LegalSection({
    required this.id,
    required this.title,
    required this.body,
    this.isCallout = false,
    this.calloutIcon,
  });

  final String id;
  final String title;
  final String body;
  final bool isCallout;
  final IconData? calloutIcon;
}

class LegalDocument {
  const LegalDocument({
    required this.id,
    required this.title,
    required this.icon,
    required this.version,
    required this.effectiveDate,
    required this.sections,
    this.showArcoButton = false,
  });

  final String id;
  final String title;
  final IconData icon;
  final String version;
  final String effectiveDate;
  final List<LegalSection> sections;
  final bool showArcoButton;
}

// ─────────────────────────────────────────────
// Aviso de Privacidad Integral
// ─────────────────────────────────────────────

final kAvisoPrivacidad = LegalDocument(
  id: 'aviso_privacidad',
  title: 'Aviso de Privacidad',
  icon: Icons.privacy_tip_outlined,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  showArcoButton: true,
  sections: [
    LegalSection(
      id: 'nota_mvp',
      title: 'Nota sobre esta versión',
      body:
          'Este Aviso de Privacidad corresponde a la versión MVP de Trama Campus. '
          'Algunos módulos descritos (procesamiento de pagos, llamadas de video, '
          'verificación de identidad avanzada) se activan progresivamente conforme '
          'la plataforma amplía su operación. El tratamiento de tus datos en cada '
          'momento estará acotado a los módulos efectivamente habilitados.',
      isCallout: true,
      calloutIcon: Icons.info_outline,
    ),
    LegalSection(
      id: 'responsable',
      title: '1. Identidad y domicilio del Responsable',
      body:
          'El responsable del tratamiento de tus datos personales es '
          '${AppInfo.legalEntityName}, con domicilio en ${AppInfo.legalEntityAddress} '
          '(en adelante "Trama Campus", "nosotros" o "el Responsable").\n\n'
          'Para cualquier asunto relacionado con este Aviso puedes contactarnos en:\n'
          '  • Privacidad: ${AppInfo.privacyEmail}\n'
          '  • Derechos ARCO: ${AppInfo.arcoEmail}\n'
          '  • Legal: ${AppInfo.legalEmail}\n\n'
          'Responsable designado de privacidad: ${AppInfo.dpoName}',
    ),
    LegalSection(
      id: 'datos_recabados',
      title: '2. Datos personales que recabamos',
      body:
          'Con tu consentimiento, recabamos las siguientes categorías de datos:\n\n'
          'a) De identificación y contacto: nombre completo, nombre de usuario, '
          'correo electrónico institucional, foto de perfil, fecha de nacimiento y género.\n\n'
          'b) Académicos e institucionales: correo de dominio universitario, '
          'universidad afiliada, programa académico, semestre y tipo de afiliación '
          '(estudiante, docente o personal).\n\n'
          'c) De preferencias e intereses: modalidades de conexión elegidas, '
          'metas personales y académicas, habilidades, pasatiempos, deportes, '
          'géneros musicales, preferencias de dieta, idiomas, rasgos de personalidad '
          'y preferencias de conexión (rangos de edad, semestre, programa y '
          'disponibilidad horaria).\n\n'
          'd) De interacción: registros de compatibilidad (likes y matches), '
          'textos de conversaciones en formato cifrado en el servidor, '
          'reportes enviados o recibidos y, cuando aplica, evaluaciones '
          'anónimas de experiencia académica.\n\n'
          'e) Derivados e inferidos: vectores de compatibilidad multidimensional '
          '(embeddings de 64 dimensiones por modalidad), indicadores de desempeño '
          'conductual en la plataforma (actividad, tasa de respuesta, reciprocidad) '
          'y puntuaciones contextuales de preferibilidad (ELO) por modalidad, '
          'calculadas a partir de comportamiento real dentro de la app.\n\n'
          'f) De ubicación: coordenadas GPS únicamente cuando el titular activa '
          'voluntariamente el check-in en un evento con verificación presencial. '
          'No se recaba ubicación de forma continua ni en segundo plano.\n\n'
          'g) Financieros: los datos de pago son procesados directamente por '
          'Stripe Connect. Trama Campus no almacena números de tarjeta, '
          'datos bancarios ni información de cuentas de pago.',
    ),
    LegalSection(
      id: 'datos_sensibles',
      title: '3. Datos personales sensibles',
      body:
          'Trama Campus trata un dato clasificado como sensible conforme al '
          'artículo 3, fracción II de la Ley Federal de Protección de Datos '
          'Personales en Posesión de los Particulares (LFPDPPP):\n\n'
          'Puntuación visual derivada (α_global): para la modalidad "Conexión '
          'personal", se calcula mediante un modelo de visión computacional '
          'una puntuación escalar que pondera claridad, iluminación, encuadre, '
          'presencia visual y atractivo facial de la fotografía de perfil. Este '
          'dato constituye un dato biométrico derivado en los términos del '
          'artículo 3, fracción II de la LFPDPPP.\n\n'
          'IMPORTANTE:\n'
          '• Esta puntuación nunca se muestra al titular ni a ningún tercero.\n'
          '• Se utiliza exclusivamente para ordenar sugerencias dentro de la '
          'modalidad "Conexión personal".\n'
          '• No se transfiere, vende ni comparte con ningún tercero.\n'
          '• Se elimina automáticamente cuando el titular desactiva la modalidad '
          '"Conexión personal" o solicita la cancelación de su cuenta.\n\n'
          'El consentimiento expreso para este tratamiento se otorga en el momento '
          'en que el titular activa la modalidad "Conexión personal" dentro de la '
          'aplicación, conforme al artículo 9 de la LFPDPPP.',
      isCallout: true,
      calloutIcon: Icons.security,
    ),
    LegalSection(
      id: 'finalidades',
      title: '4. Finalidades del tratamiento',
      body:
          'FINALIDADES PRIMARIAS (necesarias para la prestación del servicio):\n\n'
          '1. Operar el sistema de matching y generación de sugerencias de '
          'compatibilidad entre estudiantes.\n'
          '2. Verificar la afiliación universitaria mediante correo institucional y OTP.\n'
          '3. Habilitar la mensajería cifrada extremo-a-extremo entre usuarios.\n'
          '4. Gestionar la participación en grupos, comunidades y eventos.\n'
          '5. Procesar listados y transacciones en el Marketplace universitario '
          'a través de Stripe Connect.\n'
          '6. Aplicar moderación de contenido y atender reportes de conducta.\n'
          '7. Mantener la bitácora de auditoría exigida por ley.\n'
          '8. Atender el ejercicio de derechos ARCO y requerimientos legales.\n\n'
          'FINALIDADES SECUNDARIAS (no necesarias para el servicio; puedes '
          'oponerte en cualquier momento):\n\n'
          '9. Generar métricas internas anonimizadas para la mejora del producto.\n'
          '10. Enviarte comunicaciones institucionales no operativas '
          '(noticias, actualizaciones de funciones, encuestas de satisfacción).\n\n'
          'Puedes oponerte a las finalidades secundarias desde '
          'Configuración → Privacidad → Gestionar consentimientos, '
          'o escribiéndonos a ${AppInfo.arcoEmail}.',
    ),
    LegalSection(
      id: 'transferencias',
      title: '5. Transferencias de datos personales',
      body:
          'Tus datos pueden ser transferidos o tratados por los siguientes terceros:\n\n'
          'a) Stripe, Inc. (EE.UU.): procesador de pagos. Transferencia '
          'necesaria para el cumplimiento de la relación contractual contigo; '
          'no requiere tu consentimiento conforme al artículo 37, fracción I '
          'de la LFPDPPP. Stripe cumple con el Marco de Privacidad de Datos '
          'UE–EE.UU. y está sujeto a sus propias políticas de privacidad.\n\n'
          'b) LiveKit (EE.UU.): señalización de llamadas de video grupales. '
          'Actúa como encargado del tratamiento bajo instrucciones de Trama Campus.\n\n'
          'c) Tenor / Google (EE.UU.): catálogo de GIFs utilizados en '
          'mensajería. Se transmiten únicamente las consultas de búsqueda; '
          'no se envían datos personales identificables.\n\n'
          'd) Proveedor de almacenamiento de objetos (MinIO/compatible): '
          'almacena los archivos multimedia en forma cifrada. Actúa como '
          'encargado del tratamiento.\n\n'
          'Todos los datos se almacenan en servidores ubicados en México o '
          'Estados Unidos, conforme al artículo 36 de la LFPDPPP.\n\n'
          'NO compartimos tus datos personales con sponsors, anunciantes, '
          'instituciones académicas ni cualquier otro tercero salvo lo '
          'indicado en este Aviso.',
    ),
    LegalSection(
      id: 'arco',
      title: '6. Medios para ejercer los derechos ARCO',
      body:
          'Tienes derecho a Acceder, Rectificar, Cancelar u Oponerte al '
          'tratamiento de tus datos personales (derechos ARCO), conforme a '
          'los artículos 28 a 36 de la LFPDPPP.\n\n'
          'Canales para ejercerlos:\n'
          '• En la app: Configuración → Privacidad → Mis derechos ARCO\n'
          '• Por correo: ${AppInfo.arcoEmail}\n\n'
          'Plazo de respuesta: 20 días hábiles a partir de la recepción de '
          'tu solicitud, conforme al artículo 32 de la LFPDPPP.\n\n'
          'Tu solicitud debe incluir:\n'
          '• Tu nombre completo y correo registrado en la plataforma.\n'
          '• Descripción clara de los datos sobre los que ejerces el derecho.\n'
          '• Descripción del derecho que deseas ejercer (Acceso, Rectificación, '
          'Cancelación u Oposición).\n'
          '• En caso de representación legal, documentos que la acrediten.\n\n'
          'El ejercicio de estos derechos es gratuito. Las copias certificadas '
          'pueden generar un costo de reproducción razonable.',
      isCallout: true,
      calloutIcon: Icons.gavel,
    ),
    LegalSection(
      id: 'finalidades_secundarias',
      title: '7. Cómo limitar el uso de tus datos',
      body:
          'Puedes revocar el consentimiento para las finalidades secundarias '
          '(mejora del producto y comunicaciones no operativas) en cualquier '
          'momento desde:\n'
          '• Configuración → Privacidad → Gestionar consentimientos\n'
          '• Correo a ${AppInfo.arcoEmail} indicando "Oposición a finalidades secundarias"\n\n'
          'La revocación no afecta el tratamiento para finalidades primarias '
          'ni los tratamientos realizados con anterioridad.',
    ),
    LegalSection(
      id: 'cambios',
      title: '8. Cambios a este Aviso',
      body:
          'Cualquier modificación a este Aviso será notificada mediante una '
          'alerta prominente dentro de la aplicación antes de entrar en vigor. '
          'Si los cambios son materiales, podremos solicitarte una nueva '
          'aceptación expresa.\n\n'
          'La versión actualizada estará disponible en todo momento en '
          'Configuración → Centro Legal → Aviso de Privacidad, indicando '
          'la fecha de su última actualización.',
    ),
    LegalSection(
      id: 'edad',
      title: '9. Edad mínima',
      body:
          'Trama Campus está dirigido a estudiantes universitarios de al menos '
          '16 años. La modalidad "Conexión personal" requiere al menos 18 años.\n\n'
          'Si tienes conocimiento de que un menor de 16 años ha proporcionado '
          'datos personales sin consentimiento parental, notifícanos a '
          '${AppInfo.supportEmail} para eliminar esa información de inmediato.',
    ),
    LegalSection(
      id: 'vigencia',
      title: '10. Vigencia y contacto',
      body:
          'Este Aviso de Privacidad es vigente a partir del '
          '${AppInfo.legalEffectiveDate}.\n\n'
          'Para cualquier duda o aclaración:\n'
          '  • Privacidad general: ${AppInfo.privacyEmail}\n'
          '  • Derechos ARCO: ${AppInfo.arcoEmail}\n'
          '  • Legal: ${AppInfo.legalEmail}\n'
          '  • Soporte general: ${AppInfo.supportEmail}',
    ),
  ],
);

// ─────────────────────────────────────────────
// Política de Privacidad (resumen consumer)
// ─────────────────────────────────────────────

final kPrivacyPolicy = LegalDocument(
  id: 'privacy_policy',
  title: 'Política de Privacidad',
  icon: Icons.lock_outline,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  showArcoButton: true,
  sections: [
    LegalSection(
      id: 'intro',
      title: 'Tu privacidad es nuestra prioridad',
      body:
          'Esta Política resume, en lenguaje claro, cómo Trama Campus '
          'trata tus datos personales. Para el texto completo con validez legal, '
          'consulta el Aviso de Privacidad Integral disponible en Centro Legal.',
      isCallout: true,
      calloutIcon: Icons.shield_outlined,
    ),
    LegalSection(
      id: 'que_recopilamos',
      title: '1. Qué datos recopilamos',
      body:
          'Recopilamos lo que tú nos das: nombre, correo universitario, '
          'carrera, semestre, foto, intereses, metas y habilidades. '
          'También generamos datos derivados como puntuaciones de compatibilidad '
          'para mejorar tus sugerencias.\n\n'
          'Para la modalidad "Conexión personal" calculamos una puntuación '
          'visual a partir de tu foto. Esto es un dato sensible biométrico '
          'derivado; solo se activa si tú lo eliges y nunca se muestra a nadie.',
    ),
    LegalSection(
      id: 'para_que',
      title: '2. Para qué los usamos',
      body:
          'Usamos tus datos para conectarte con estudiantes compatibles, '
          'verificar tu afiliación universitaria, operar la mensajería cifrada, '
          'gestionar grupos y eventos, y procesar transacciones en el Marketplace. '
          'No vendemos tus datos a nadie.',
    ),
    LegalSection(
      id: 'con_quien',
      title: '3. Con quién los compartimos',
      body:
          'Solo con los proveedores tecnológicos necesarios para operar el servicio: '
          'Stripe para pagos, LiveKit para videollamadas grupales y nuestro '
          'proveedor de almacenamiento para archivos cifrados. '
          'Todos actúan bajo nuestras instrucciones. '
          'Los datos se guardan únicamente en México o EE.UU.',
    ),
    LegalSection(
      id: 'seguridad',
      title: '4. Cómo los protegemos',
      body:
          'Tus mensajes están cifrados de extremo a extremo (nadie en Trama Campus '
          'puede leer su contenido). Las contraseñas se almacenan con bcrypt. '
          'Los archivos multimedia se cifran antes de subirse al servidor. '
          'Hacemos respaldos diarios y aplicamos controles de acceso estrictos.',
    ),
    LegalSection(
      id: 'retencion',
      title: '5. Cuánto tiempo conservamos tus datos',
      body:
          'Mientras tu cuenta esté activa. Si la desactivas, tienes 30 días para '
          'reactivarla; después la eliminamos de forma definitiva. '
          'Los mensajes cifrados en el servidor se borran a los 90 días. '
          'La bitácora de moderación se conserva 2 años por obligación legal.',
    ),
    LegalSection(
      id: 'derechos',
      title: '6. Tus derechos',
      body:
          'Tienes derechos ARCO: Acceso, Rectificación, Cancelación y Oposición. '
          'Puedes ejercerlos directamente en la app (Configuración → Privacidad → '
          'Mis derechos ARCO) o escribiéndonos a ${AppInfo.arcoEmail}. '
          'Respondemos en 20 días hábiles.',
    ),
    LegalSection(
      id: 'actualizaciones',
      title: '7. Actualizaciones a esta política',
      body:
          'Si hacemos cambios importantes, te lo notificamos dentro de la app '
          'antes de que entren en vigor. La fecha de la última actualización '
          'aparece en la parte superior de este documento.',
    ),
  ],
);

// ─────────────────────────────────────────────
// Términos y Condiciones
// ─────────────────────────────────────────────

final kTermsConditions = LegalDocument(
  id: 'terms_conditions',
  title: 'Términos y Condiciones',
  icon: Icons.article_outlined,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  sections: [
    LegalSection(
      id: 'aceptacion',
      title: '1. Aceptación de los Términos',
      body:
          'Al crear una cuenta y utilizar Trama Campus aceptas, en su totalidad, '
          'estos Términos y Condiciones ("Términos"), el Aviso de Privacidad, '
          'la Política de Privacidad y las demás políticas aplicables publicadas '
          'en el Centro Legal de la aplicación. Si no estás de acuerdo con '
          'alguna disposición, debes abstenerte de usar la plataforma.\n\n'
          'La aceptación expresa se produce en la pantalla de consentimiento '
          'que precede al registro y queda registrada con la versión de '
          'documentos vigente en ese momento.',
    ),
    LegalSection(
      id: 'definiciones',
      title: '2. Definiciones',
      body:
          '"Plataforma" — la aplicación móvil Trama Campus, sus APIs y servicios asociados.\n'
          '"Trama Campus" / "nosotros" — ${AppInfo.legalEntityName}.\n'
          '"Usuario" — toda persona física registrada en la Plataforma.\n'
          '"Estudiante Verificado" — usuario que completó la verificación con '
          'correo institucional vigente y, en su caso, la verificación de identidad '
          'para operar en el Marketplace.\n'
          '"Empresa Sponsor" — entidad externa aprobada por Trama Campus para '
          'acceder al perfil empresarial dentro de la Plataforma.\n'
          '"Modalidad" — categoría de conexión habilitada por el usuario '
          '(Estudio, Amistad, Conexión personal, etc.).\n'
          '"Match" — conexión mutua entre dos usuarios dentro de una misma Modalidad.\n'
          '"Contenido" — cualquier texto, imagen, audio o dato que el usuario '
          'sube, comparte o genera en la Plataforma.',
    ),
    LegalSection(
      id: 'elegibilidad',
      title: '3. Elegibilidad y cuenta',
      body:
          'Para registrarte en Trama Campus debes:\n'
          '• Ser estudiante, docente o personal de una institución universitaria afiliada.\n'
          '• Tener al menos 16 años de edad. La modalidad "Conexión personal" '
          'requiere al menos 18 años.\n'
          '• Contar con un correo electrónico del dominio institucional de tu campus.\n\n'
          'Eres responsable de mantener la confidencialidad de tus credenciales '
          'de acceso. Cualquier actividad realizada desde tu cuenta es tu '
          'responsabilidad. Debes notificarnos de inmediato si detectas acceso '
          'no autorizado a tu cuenta en ${AppInfo.supportEmail}.',
    ),
    LegalSection(
      id: 'verificacion',
      title: '4. Verificación universitaria',
      body:
          'El acceso a la Plataforma requiere una dirección de correo del dominio '
          'habilitado por tu institución (ej. @anahuac.mx). Al registrarte '
          'recibirás un código de verificación de un solo uso (OTP) para confirmar '
          'que tienes acceso a esa cuenta de correo.\n\n'
          'La afiliación como docente o personal requiere revisión manual por '
          'parte del equipo de Trama Campus, con un plazo de respuesta de hasta '
          '72 horas hábiles. La cuenta permanece inactiva hasta la aprobación.\n\n'
          'Para publicar y vender en el Marketplace se requiere completar una '
          'verificación de identidad adicional (KYC) a través de Stripe Connect.',
    ),
    LegalSection(
      id: 'conducta',
      title: '5. Conducta del usuario',
      body:
          'Al usar Trama Campus te comprometes a:\n'
          '• Mantener un perfil auténtico con tu identidad real.\n'
          '• Tratar a todos los usuarios con respeto y dignidad.\n'
          '• Cumplir con la Política de Comunidad y Moderación.\n\n'
          'Está estrictamente prohibido:\n'
          '• Acosar, amenazar o intimidar a otros usuarios.\n'
          '• Suplantar la identidad de otra persona o institución.\n'
          '• Publicar contenido ilegal, violento, sexualmente explícito sin '
          'el consentimiento expreso de los involucrados o discriminatorio.\n'
          '• Usar la Plataforma para spam, reclutamiento engañoso o '
          'actividades comerciales no autorizadas.\n'
          '• Intentar acceder a sistemas o datos ajenos de forma no autorizada.',
    ),
    LegalSection(
      id: 'contenido',
      title: '6. Contenido del usuario',
      body:
          'Tú conservas todos los derechos sobre el Contenido que publicas. '
          'Al hacerlo, nos otorgas una licencia limitada, no exclusiva, '
          'revocable, libre de regalías y global para almacenar, mostrar '
          'y transmitir ese Contenido únicamente con el fin de operar la '
          'Plataforma y ofrecerte el servicio.\n\n'
          'Esta licencia termina cuando eliminas el Contenido o tu cuenta, '
          'sujeto a los plazos de retención indicados en la Política de '
          'Eliminación de Cuenta y Retención de Datos.',
    ),
    LegalSection(
      id: 'matching',
      title: '7. Modalidades de matching',
      body:
          'Trama Campus ofrece distintas modalidades de conexión entre '
          'estudiantes. Para cada modalidad que actives, la Plataforma '
          'calculará una puntuación de compatibilidad basada en tus datos '
          'de perfil, preferencias y comportamiento dentro de la app.\n\n'
          'La modalidad "Conexión personal" es exclusiva para usuarios '
          'de al menos 18 años. Al activarla, otorgas consentimiento expreso '
          'para el tratamiento de la puntuación visual derivada descrita en '
          'el Aviso de Privacidad. Puedes desactivar esta modalidad en '
          'cualquier momento desde Configuración → Modalidades.',
    ),
    LegalSection(
      id: 'mensajeria',
      title: '8. Mensajería cifrada',
      body:
          'Los mensajes entre usuarios están cifrados de extremo a extremo '
          'usando el protocolo MLS (RFC 9420). Trama Campus no puede leer '
          'el contenido de tus mensajes; el servidor almacena y retransmite '
          'únicamente texto cifrado opaco.\n\n'
          'Los mensajes en el servidor se eliminan automáticamente a los '
          '90 días. Tu cliente puede conservar copias locales más allá de '
          'ese plazo, bajo tu propia responsabilidad.',
    ),
    LegalSection(
      id: 'marketplace',
      title: '9. Marketplace universitario',
      body:
          'El uso del Marketplace está sujeto además a la Política de '
          'Marketplace disponible en el Centro Legal. En síntesis:\n\n'
          '• Trama Campus actúa como intermediario técnico, no como parte '
          'en los contratos de compraventa entre usuarios.\n'
          '• Los pagos se procesan exclusivamente a través de Stripe Connect.\n'
          '• Los vendedores son responsables de la exactitud de sus anuncios '
          'y del cumplimiento de la legislación fiscal aplicable.',
    ),
    LegalSection(
      id: 'grupos',
      title: '10. Grupos y Comunidades',
      body:
          'El uso de grupos está sujeto a la Política de Comunidad y Moderación. '
          'El administrador de cada grupo es responsable de moderar el contenido '
          'que se comparte dentro de él y de hacer cumplir las normas de la '
          'Plataforma entre sus integrantes.',
    ),
    LegalSection(
      id: 'modelo_negocio',
      title: '11. Modelo de negocio y tarifas',
      body:
          'Trama Campus es gratuito para todos los usuarios estudiantes. '
          'La monetización es exclusivamente B2B: empresas y organizaciones '
          'externas pagan por planes de presencia en la Plataforma '
          '(Básico, Pro y Sponsor) y por comisiones sobre transacciones '
          'del Marketplace.\n\n'
          'No existe ni existirá un nivel de suscripción de pago para estudiantes.',
      isCallout: true,
      calloutIcon: Icons.check_circle_outline,
    ),
    LegalSection(
      id: 'propiedad_intelectual',
      title: '12. Propiedad intelectual',
      body:
          'Todo el diseño, código fuente, logotipos, tipografía, elementos '
          'visuales y textos propios de Trama Campus son propiedad intelectual '
          'del Responsable o de sus licenciantes y están protegidos por la '
          'Ley Federal del Derecho de Autor y tratados internacionales aplicables.\n\n'
          'Queda prohibida la reproducción, modificación o distribución de '
          'cualquier elemento de la Plataforma sin autorización escrita previa.',
    ),
    LegalSection(
      id: 'limitacion_responsabilidad',
      title: '13. Limitación de responsabilidad',
      body:
          'La Plataforma se ofrece "tal como está" y "según disponibilidad". '
          'No garantizamos la disponibilidad continua del servicio ni la '
          'exactitud de los perfiles de otros usuarios.\n\n'
          'Trama Campus actúa como intermediario técnico para las conexiones '
          'entre usuarios y las transacciones del Marketplace. No somos parte '
          'en los contratos celebrados entre usuarios, ni garantizamos el '
          'comportamiento o la identidad de ningún usuario.\n\n'
          'En ningún caso seremos responsables de daños indirectos, incidentales, '
          'especiales o consecuentes derivados del uso o la imposibilidad de '
          'usar la Plataforma, salvo lo dispuesto por la legislación mexicana.',
    ),
    LegalSection(
      id: 'suspension',
      title: '14. Suspensión y terminación',
      body:
          'Trama Campus puede suspender o terminar tu acceso a la Plataforma, '
          'de forma temporal o definitiva, cuando exista:\n'
          '• Violación de estos Términos o de las políticas de la Plataforma.\n'
          '• Conducta que ponga en riesgo la seguridad de otros usuarios.\n'
          '• Requerimiento de autoridad competente.\n'
          '• Inactividad prolongada (más de 12 meses sin iniciar sesión).\n\n'
          'La desactivación temporal de tu cuenta preserva tus datos durante '
          '30 días; la eliminación definitiva borra tus datos conforme a la '
          'Política de Eliminación de Cuenta y Retención de Datos.',
    ),
    LegalSection(
      id: 'modificaciones',
      title: '15. Modificaciones a los Términos',
      body:
          'Nos reservamos el derecho de modificar estos Términos en cualquier '
          'momento. Los cambios materiales se notificarán mediante una alerta '
          'en la app con al menos 15 días naturales de anticipación. El uso '
          'continuado después de esa fecha implica la aceptación de los '
          'Términos actualizados.',
    ),
    LegalSection(
      id: 'ley_aplicable',
      title: '16. Ley aplicable y jurisdicción',
      body:
          'Estos Términos se rigen por la legislación vigente de los Estados '
          'Unidos Mexicanos. Para la resolución de cualquier controversia, '
          'las partes se someten a la competencia de los tribunales del '
          'domicilio del Responsable, renunciando a cualquier otro fuero '
          'que pudiera corresponderles.',
    ),
    LegalSection(
      id: 'contacto',
      title: '17. Contacto legal',
      body:
          'Para cualquier duda, reclamación o notificación relacionada con '
          'estos Términos:\n'
          '  ${AppInfo.legalEmail}',
    ),
  ],
);

// ─────────────────────────────────────────────
// Derechos ARCO
// ─────────────────────────────────────────────

final kArcoRights = LegalDocument(
  id: 'arco_rights',
  title: 'Derechos ARCO',
  icon: Icons.gavel,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  showArcoButton: true,
  sections: [
    LegalSection(
      id: 'intro',
      title: 'Tus datos son tuyos',
      body:
          'La Ley Federal de Protección de Datos Personales en Posesión de '
          'los Particulares (LFPDPPP) te otorga cuatro derechos fundamentales '
          'sobre tus datos personales: Acceso, Rectificación, Cancelación y '
          'Oposición — en conjunto, "derechos ARCO".',
      isCallout: true,
      calloutIcon: Icons.shield_outlined,
    ),
    LegalSection(
      id: 'acceso',
      title: 'Acceso',
      body:
          'Derecho a conocer qué datos personales tenemos sobre ti, '
          'para qué los usamos, con quién los compartimos y el origen '
          'del que los obtuvimos.\n\n'
          'Ejemplo: solicitar una copia de tu perfil, tus preferencias '
          'guardadas, tu historial de matches y los metadatos de tu cuenta.',
    ),
    LegalSection(
      id: 'rectificacion',
      title: 'Rectificación',
      body:
          'Derecho a corregir tus datos personales cuando sean inexactos, '
          'incompletos o estén desactualizados.\n\n'
          'Ejemplo: actualizar tu nombre si cambió, corregir tu fecha de '
          'nacimiento o modificar tu carrera. Nota: muchos datos los puedes '
          'actualizar directamente en Editar Perfil sin necesidad de una '
          'solicitud formal.',
    ),
    LegalSection(
      id: 'cancelacion',
      title: 'Cancelación',
      body:
          'Derecho a que eliminemos tus datos personales cuando ya no sean '
          'necesarios para las finalidades del tratamiento, o cuando revocas '
          'tu consentimiento.\n\n'
          'La cancelación puede implicar un período de bloqueo previo a la '
          'eliminación para proteger los derechos de terceros o cumplir '
          'obligaciones legales (por ejemplo, la bitácora de moderación se '
          'conserva 2 años por mandato legal). Después de ese período, '
          'los datos se eliminan de forma definitiva.',
    ),
    LegalSection(
      id: 'oposicion',
      title: 'Oposición',
      body:
          'Derecho a oponerte al tratamiento de tus datos para finalidades '
          'específicas, aun cuando el tratamiento sea lícito.\n\n'
          'Ejemplo: oponerte al tratamiento de tus datos para la generación '
          'de métricas internas o para recibir comunicaciones no operativas '
          'de Trama Campus.',
    ),
    LegalSection(
      id: 'quien_puede',
      title: 'Quién puede ejercerlos',
      body:
          'Tú mismo como titular de los datos, o tu representante legal debidamente acreditado.\n\n'
          'En caso de representación legal, deberás adjuntar:\n'
          '• Instrumento notarial o carta poder firmada ante dos testigos.\n'
          '• Identificación oficial vigente del titular y del representante.',
    ),
    LegalSection(
      id: 'requisitos',
      title: 'Requisitos de la solicitud',
      body:
          'Conforme al artículo 29 de la LFPDPPP, tu solicitud debe incluir:\n\n'
          '1. Tu nombre completo y correo electrónico con el que te registraste '
          '(este correo acredita tu identidad ante nosotros).\n'
          '2. Descripción clara y precisa de los datos personales sobre los que '
          'deseas ejercer el derecho.\n'
          '3. El derecho específico que deseas ejercer (Acceso, Rectificación, '
          'Cancelación u Oposición).\n'
          '4. Si es Rectificación: los cambios solicitados y la documentación '
          'que los sustente.\n'
          '5. Cualquier otro elemento que facilite la localización de tus datos.',
    ),
    LegalSection(
      id: 'plazos',
      title: 'Plazos y costos',
      body:
          'Plazo de respuesta: 20 días hábiles a partir de la recepción de '
          'tu solicitud (artículo 32, LFPDPPP). En casos complejos este plazo '
          'puede ampliarse por otros 20 días hábiles, notificándotelo.\n\n'
          'Costo: el ejercicio de derechos ARCO es gratuito. Las copias '
          'certificadas de documentos pueden tener un costo de reproducción '
          'razonable, que te comunicaremos antes de generarlas.\n\n'
          'Si consideras que tu solicitud fue rechazada indebidamente, puedes '
          'presentar una queja ante el INAI (www.inai.org.mx).',
      isCallout: true,
      calloutIcon: Icons.access_time,
    ),
    LegalSection(
      id: 'como_iniciar',
      title: 'Cómo iniciar una solicitud',
      body:
          'Tienes dos vías:\n\n'
          '1. En la app: usa el botón "Iniciar solicitud ARCO" en esta pantalla. '
          'El sistema generará un correo formal prellenado con tus datos y '
          'los datos de la solicitud, listo para enviarlo a ${AppInfo.arcoEmail}.\n\n'
          '2. Por correo directo: envía tu solicitud a ${AppInfo.arcoEmail} '
          'con los requisitos descritos arriba.',
    ),
  ],
);

// ─────────────────────────────────────────────
// Política de Marketplace
// ─────────────────────────────────────────────

final kMarketplacePolicy = LegalDocument(
  id: 'marketplace_policy',
  title: 'Política de Marketplace',
  icon: Icons.store_outlined,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  sections: [
    LegalSection(
      id: 'intro',
      title: 'El Marketplace universitario',
      body:
          'El Marketplace de Trama Campus es un espacio donde Estudiantes '
          'Verificados y Empresas Sponsor pueden publicar productos, servicios '
          'y oportunidades dirigidos a la comunidad universitaria. '
          'Trama Campus actúa como intermediario técnico y no es parte en los '
          'contratos celebrados entre compradores y vendedores.',
      isCallout: true,
      calloutIcon: Icons.storefront_outlined,
    ),
    LegalSection(
      id: 'quien_puede_vender',
      title: '1. Quién puede publicar',
      body:
          'Pueden publicar en el Marketplace:\n\n'
          '• Estudiantes Verificados: quienes completaron la verificación de '
          'identidad con credencial institucional vigente (KYC vía Stripe Connect).\n'
          '• Empresas Sponsor: entidades externas aprobadas por el equipo de '
          'Trama Campus y con acuerdo de colaboración vigente.\n\n'
          'Los usuarios sin verificación pueden navegar y comprar, '
          'pero no pueden publicar listados.',
    ),
    LegalSection(
      id: 'categorias_permitidas',
      title: '2. Categorías permitidas',
      body:
          'Los Estudiantes Verificados pueden publicar en las siguientes categorías:\n'
          '• Apuntes y material de estudio\n'
          '• Servicios freelance (diseño, programación, idiomas, tutorías)\n'
          '• Artículos físicos (libros de texto, equipo de estudio, artículos de segunda mano)\n'
          '• Compañero de cuarto (roomie)\n\n'
          'Las Empresas Sponsor pueden publicar adicionalmente en:\n'
          '• Categoría Business: promociones, servicios y productos corporativos.',
    ),
    LegalSection(
      id: 'categorias_prohibidas',
      title: '3. Categorías prohibidas',
      body:
          'Está estrictamente prohibido publicar:\n'
          '• Sustancias controladas o medicamentos sin receta.\n'
          '• Armas, municiones o artículos peligrosos.\n'
          '• Contenido sexualmente explícito o servicios de naturaleza sexual.\n'
          '• Productos o servicios que infrinjan derechos de autor, marcas '
          'registradas u otra propiedad intelectual ajena.\n'
          '• Artículos falsificados o de procedencia ilegal.\n'
          '• Servicios de tramitación de tareas, exámenes o trabajos académicos.\n'
          '• Actividades de marketing multinivel o esquemas piramidales.\n\n'
          'La publicación de contenido prohibido conllevará la eliminación '
          'inmediata del listado y puede resultar en la suspensión de la cuenta.',
    ),
    LegalSection(
      id: 'kyc',
      title: '4. Verificación de identidad (KYC)',
      body:
          'Para recibir pagos en el Marketplace, cada vendedor debe completar '
          'el proceso de incorporación KYC (Know Your Customer) de Stripe Connect. '
          'Este proceso es gestionado íntegramente por Stripe; Trama Campus no '
          'recibe ni almacena datos bancarios, de tarjeta ni documentos de '
          'identificación del proceso KYC.',
    ),
    LegalSection(
      id: 'comisiones',
      title: '5. Pagos y comisiones',
      body:
          'Los pagos se procesan exclusivamente a través de Stripe Connect '
          'mediante la generación de un PaymentIntent por transacción.\n\n'
          'Comisiones de la plataforma (sobre el monto de la transacción, '
          'además de las tarifas propias de Stripe):\n\n'
          'Estudiantes — fase beta:\n'
          '  0% de comisión (solo aplican tarifas de Stripe)\n\n'
          'Estudiantes — fase post-beta:\n'
          '  1.5% si el monto es menor a MXN \$1,000\n'
          '  0.7% si el monto es igual o mayor a MXN \$1,000\n\n'
          'Empresas — fase beta:\n'
          '  3% más tarifas de Stripe\n\n'
          'Empresas — fase post-beta:\n'
          '  6% más tarifas de Stripe\n\n'
          'Las comisiones se descuentan automáticamente en el momento del cobro.',
    ),
    LegalSection(
      id: 'boosts',
      title: '6. Visibilidad pagada (Boosts)',
      body:
          'Los vendedores pueden contratar Boosts de posición para destacar '
          'su listado en la parte superior de su categoría durante un período determinado:\n\n'
          'Estudiantes: MXN \$29 (7 días) / \$49 (15 días) / \$79 (40 días)\n'
          'Empresas: MXN \$149 (7 días) / \$249 (15 días) / \$399 (40 días)\n\n'
          'Al vencer el período, el listado regresa a su posición orgánica. '
          'Los Boosts no garantizan ventas y no son reembolsables salvo falla técnica.',
    ),
    LegalSection(
      id: 'responsabilidad',
      title: '7. Responsabilidad de la plataforma',
      body:
          'Trama Campus actúa como intermediario técnico. No somos parte en '
          'ningún contrato de compraventa entre usuarios, y no asumimos '
          'responsabilidad por:\n'
          '• La calidad, exactitud o legalidad de los listados.\n'
          '• El incumplimiento de obligaciones entre compradores y vendedores.\n'
          '• Las consecuencias fiscales de las transacciones (cada vendedor '
          'es responsable de sus propias obligaciones fiscales ante el SAT).\n\n'
          'Trama Campus se reserva el derecho de suspender listados o cuentas '
          'que violen esta política o los Términos y Condiciones generales.',
    ),
    LegalSection(
      id: 'disputas',
      title: '8. Resolución de disputas',
      body:
          'En caso de disputa entre comprador y vendedor:\n\n'
          '1. Las partes deben intentar resolverla directamente a través del '
          'sistema de mensajería de la app.\n'
          '2. Si no se llega a un acuerdo, cualquiera de las partes puede '
          'solicitar mediación a Trama Campus en ${AppInfo.supportEmail}.\n'
          '3. Los contracargos y disputas de pago formales se gestionan a '
          'través del sistema de resolución de disputas de Stripe.\n\n'
          'Trama Campus se reserva el derecho de bloquear temporalmente los '
          'fondos de una transacción mientras se resuelve una disputa activa.',
    ),
  ],
);

// ─────────────────────────────────────────────
// Política de Sponsors y Partners
// ─────────────────────────────────────────────

final kSponsorsPolicy = LegalDocument(
  id: 'sponsors_policy',
  title: 'Política de Sponsors',
  icon: Icons.business_center_outlined,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  sections: [
    LegalSection(
      id: 'definicion',
      title: '1. ¿Qué es una Empresa Sponsor?',
      body:
          'Una Empresa Sponsor es una entidad externa (empresa, marca, '
          'organización o institución) verificada y aprobada por el equipo '
          'de Trama Campus para acceder a un perfil empresarial dentro de la '
          'Plataforma con funcionalidades configuradas a medida.\n\n'
          'La condición de Empresa Sponsor requiere una revisión manual del '
          'equipo de Trama Campus y la firma de un acuerdo de colaboración. '
          'No se otorga por autodeclaración.',
    ),
    LegalSection(
      id: 'incorporacion',
      title: '2. Proceso de incorporación',
      body:
          'Para convertirse en Empresa Sponsor:\n'
          '1. Solicitar incorporación a través de ${AppInfo.legalEmail}.\n'
          '2. Proporcionar documentación de constitución legal y representación.\n'
          '3. Firmar el Acuerdo de Colaboración de Trama Campus.\n'
          '4. Completar el onboarding KYC de Stripe Connect si el plan '
          'incluye transacciones en el Marketplace.\n\n'
          'El equipo de Trama Campus puede rechazar solicitudes sin necesidad '
          'de justificar la decisión.',
    ),
    LegalSection(
      id: 'planes',
      title: '3. Planes y beneficios',
      body:
          'Trama Campus ofrece tres planes para Empresas Sponsor:\n\n'
          'Plan Básico (MXN \$599/mes, post-beta):\n'
          '  • Perfil empresarial en la Plataforma\n'
          '  • Publicación en el Marketplace (comisión aplicable)\n'
          '  • Estadísticas básicas de visitas a perfil\n\n'
          'Plan Pro (MXN \$1,299/mes, post-beta):\n'
          '  • Todo el plan Básico\n'
          '  • Posicionamiento mejorado en búsquedas\n'
          '  • Estadísticas avanzadas\n\n'
          'Plan Sponsor (MXN \$2,499/mes, post-beta):\n'
          '  • Todo el plan Pro\n'
          '  • Badge "Sponsor Verificado" visible en perfil\n'
          '  • Posicionamiento prioritario\n'
          '  • Soporte dedicado\n\n'
          'Los precios son exclusivos para la fase post-beta y pueden '
          'cambiar con notificación previa de 30 días.',
    ),
    LegalSection(
      id: 'datos_visibles',
      title: '4. Datos que los Sponsors pueden ver',
      body:
          'Una Empresa Sponsor solo puede acceder a los siguientes datos de usuarios:\n\n'
          '• Número de visitas a su perfil empresarial (agregado, sin identificar usuarios).\n'
          '• Conversaciones que el usuario inició voluntariamente con la empresa.\n'
          '• Reservas o consultas realizadas directamente por el usuario.\n'
          '• Datos que el usuario proporcione en formularios de contacto dentro del perfil sponsor.\n\n'
          'Todos estos datos corresponden a interacciones explícitas e iniciadas por el usuario.',
    ),
    LegalSection(
      id: 'datos_no_visibles',
      title: '5. Datos que los Sponsors NO pueden ver',
      body:
          'Está estrictamente prohibido compartir con Sponsors:\n'
          '• Datos de identificación de usuarios (nombre, correo, teléfono) sin consentimiento expreso del usuario.\n'
          '• Vectores de compatibilidad, puntuaciones Elo ni scores de atractivo visual.\n'
          '• Contenido de conversaciones privadas entre usuarios.\n'
          '• Historial de matches o likes.\n'
          '• Ubicación o datos de geofence.\n'
          '• Datos académicos (carrera, semestre, notas).\n\n'
          'Trama Campus no realiza targeting publicitario basado en datos '
          'personales identificables de los usuarios.',
      isCallout: true,
      calloutIcon: Icons.block,
    ),
    LegalSection(
      id: 'publicidad',
      title: '6. Publicidad y promociones',
      body:
          'En la versión actual de Trama Campus no existe publicidad programática '
          'ni targeting basado en datos personales del usuario.\n\n'
          'Los Sponsors pueden publicar promociones en su propio perfil dentro '
          'de la Plataforma. El usuario interactúa con ellas de forma voluntaria '
          'al visitar el perfil o contactar al Sponsor.\n\n'
          'Si en el futuro se introducen mecanismos de publicidad que impliquen '
          'tratamiento adicional de datos personales, se actualizará el Aviso '
          'de Privacidad y se solicitará un nuevo consentimiento.',
    ),
    LegalSection(
      id: 'terminacion',
      title: '7. Terminación del acuerdo',
      body:
          'El acuerdo de colaboración puede terminar por:\n'
          '• Incumplimiento de los Términos y Condiciones o de esta política.\n'
          '• Decisión unilateral de Trama Campus con aviso de 30 días.\n'
          '• Solicitud del propio Sponsor.\n\n'
          'Al terminar, se desactiva el perfil empresarial y se suspenden '
          'los listados activos. Los datos de transacciones completadas se '
          'conservan conforme a la legislación fiscal aplicable.',
    ),
  ],
);

// ─────────────────────────────────────────────
// Política de Comunidad
// ─────────────────────────────────────────────

final kCommunityPolicy = LegalDocument(
  id: 'community_policy',
  title: 'Comunidad y Normas',
  icon: Icons.groups_outlined,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  sections: [
    LegalSection(
      id: 'principios',
      title: 'Principios fundamentales',
      body:
          'Trama Campus es un espacio diseñado para conexiones universitarias '
          'auténticas, respetuosas y con propósito. Cada usuario es responsable '
          'de la forma en que interactúa dentro de la Plataforma. '
          'Estas normas protegen a todos los miembros de la comunidad.',
      isCallout: true,
      calloutIcon: Icons.favorite_border,
    ),
    LegalSection(
      id: 'conducta_esperada',
      title: '1. Conducta esperada',
      body:
          '• Sé auténtico: usa tu nombre real, sube fotos tuyas y describe '
          'con honestidad tus intereses y objetivos.\n'
          '• Trata a todos con respeto y dignidad, independientemente de su '
          'género, orientación, origen, religión, capacidad o cualquier otra condición.\n'
          '• Comunica tus intenciones con claridad y honestidad.\n'
          '• Respeta los límites de otros usuarios cuando los expresan.\n'
          '• Reporta conductas que violen estas normas en lugar de responder '
          'con más conflicto.',
    ),
    LegalSection(
      id: 'contenido_prohibido',
      title: '2. Contenido prohibido',
      body:
          'Está absolutamente prohibido en la Plataforma:\n\n'
          '• Acoso, amenazas, intimidación o conducta violenta.\n'
          '• Discurso de odio basado en raza, etnia, género, orientación sexual, '
          'religión, discapacidad, origen nacional u otras características protegidas.\n'
          '• Contenido sexualmente explícito no consensuado o que involucre menores.\n'
          '• Doxxing: publicar información personal de otros sin su consentimiento.\n'
          '• Suplantación de identidad de personas, marcas o instituciones.\n'
          '• Spam, cadenas de mensajes, contenido repetitivo o publicidad no autorizada.\n'
          '• Contenido que promueva actividades ilegales, incluyendo tráfico de '
          'sustancias, armas o fraude.\n'
          '• Uso de obras protegidas por derechos de autor sin licencia.',
    ),
    LegalSection(
      id: 'conexion_personal',
      title: '3. Modalidad "Conexión personal"',
      body:
          'La modalidad "Conexión personal" es exclusiva para usuarios de al '
          'menos 18 años y opera bajo consentimiento expreso.\n\n'
          '• Cualquier interacción debe ser mutuamente consentida.\n'
          '• No tolerar el acoso o la insistencia tras una respuesta negativa.\n'
          '• El uso de esta modalidad con fines de extorsión, sextorsión o '
          'distribución de imágenes íntimas sin consentimiento resultará en '
          'la suspensión permanente de la cuenta y puede ser denunciado '
          'ante las autoridades competentes.',
      isCallout: true,
      calloutIcon: Icons.favorite,
    ),
    LegalSection(
      id: 'reportes',
      title: '4. Cómo reportar infracciones',
      body:
          'Si encuentras contenido o comportamiento que viole estas normas:\n\n'
          '1. Usa el botón "Reportar" en el perfil del usuario, listado o mensaje.\n'
          '2. Selecciona el tipo de infracción y proporciona contexto si es posible.\n'
          '3. Nuestro equipo revisará el reporte dentro de las 48 horas hábiles siguientes.\n\n'
          'También puedes contactarnos directamente en ${AppInfo.supportEmail} '
          'para casos urgentes o que involucren seguridad personal.',
    ),
    LegalSection(
      id: 'sanciones',
      title: '5. Consecuencias y sanciones',
      body:
          'Las infracciones a estas normas pueden resultar en:\n\n'
          '• Advertencia formal documentada en la cuenta.\n'
          '• Restricción temporal de funciones específicas (mensajes, Marketplace, grupos).\n'
          '• Suspensión temporal de la cuenta (24 horas a 30 días).\n'
          '• Eliminación permanente de la cuenta sin posibilidad de reactivación.\n\n'
          'La gravedad de la sanción depende de la naturaleza de la infracción, '
          'su reincidencia y el impacto en otros usuarios. Las infracciones graves '
          '(doxxing, suplantación, contenido sexual de menores, extorsión) '
          'resultan en eliminación permanente de inmediato y, cuando corresponda, '
          'denuncia ante las autoridades.',
    ),
    LegalSection(
      id: 'apelaciones',
      title: '6. Apelaciones',
      body:
          'Si consideras que una sanción fue aplicada por error, puedes apelar:\n\n'
          '1. Envía un correo a ${AppInfo.supportEmail} con el asunto '
          '"Apelación de moderación" dentro de los 15 días hábiles '
          'siguientes a la notificación de la sanción.\n'
          '2. Incluye tu nombre de usuario, la fecha de la sanción y '
          'los motivos por los que consideras que fue incorrecta.\n'
          '3. El equipo de Trama Campus revisará la apelación en un plazo '
          'de 10 días hábiles y te comunicará su resolución definitiva.',
    ),
    LegalSection(
      id: 'admin_grupos',
      title: '7. Rol del administrador de grupo',
      body:
          'El administrador (creador) de un grupo es responsable de:\n'
          '• Moderar el contenido compartido dentro de su grupo.\n'
          '• Hacer cumplir estas normas entre los integrantes.\n'
          '• Configurar correctamente el nivel de acceso (abierto, solicitud '
          'o solo invitación) conforme a la naturaleza del grupo.\n\n'
          'Trama Campus puede intervenir en cualquier grupo si recibe reportes '
          'de violaciones, independientemente de la acción del administrador.',
    ),
    LegalSection(
      id: 'anonimato',
      title: '8. Anonimato y privacidad',
      body:
          'Algunos grupos y las evaluaciones académicas pueden operar en modo '
          'anónimo. En esos espacios:\n'
          '• Tu identidad no es visible para otros participantes.\n'
          '• Sin embargo, Trama Campus conserva un token de resolución de '
          'anonimato que puede ser activado únicamente bajo doble control '
          '(requiere la autorización simultánea de un Administrador y un '
          'Administrador de Sistema) o en caso de emergencia legal.\n'
          '• Toda resolución de anonimato queda registrada de forma inmutable.\n\n'
          'El anonimato no protege conductas que violen estas normas.',
    ),
  ],
);

// ─────────────────────────────────────────────
// Política de Moderación
// ─────────────────────────────────────────────

final kModerationPolicy = LegalDocument(
  id: 'moderation_policy',
  title: 'Política de Moderación',
  icon: Icons.admin_panel_settings,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  sections: [
    LegalSection(
      id: 'quienes_moderan',
      title: '1. Quién modera',
      body:
          'La moderación de Trama Campus opera en dos capas complementarias:\n\n'
          'a) Moderación automatizada: filtros de procesamiento de lenguaje natural '
          '(NLP) que analizan el contenido publicado en tiempo real. El sistema '
          'detecta automáticamente toxicidad, ataques personales, revelación de '
          'información sensible, spam coordinado y sesgos discriminatorios. '
          'Cuando la confianza del sistema es alta, el contenido se rechaza automáticamente. '
          'Los casos ambiguos pasan a revisión humana.\n\n'
          'b) Moderación humana: el equipo de Trama Campus revisa los reportes '
          'enviados por usuarios, los casos en zona gris del sistema automático '
          'y las apelaciones. Todas las decisiones quedan registradas en la '
          'bitácora inmutable de moderación.',
    ),
    LegalSection(
      id: 'proceso',
      title: '2. Proceso de revisión',
      body:
          'Al recibir un reporte:\n\n'
          '1. El contenido reportado es marcado para revisión y puede ser '
          'ocultado temporalmente si el sistema lo considera de riesgo alto.\n'
          '2. Un moderador humano evalúa el contexto completo dentro de las '
          '48 horas hábiles siguientes.\n'
          '3. La decisión puede ser: desestimar el reporte, emitir advertencia, '
          'restringir funciones, suspender la cuenta o eliminarla permanentemente.\n'
          '4. El usuario afectado recibe notificación de la decisión.',
    ),
    LegalSection(
      id: 'sanciones_progresivas',
      title: '3. Sanciones progresivas',
      body:
          'La gravedad de las sanciones escala con la reincidencia y la '
          'gravedad de la infracción:\n\n'
          'Nivel 1 — Advertencia:\n'
          'Primera infracción leve. El contenido se elimina y se notifica al usuario.\n\n'
          'Nivel 2 — Restricción temporal:\n'
          'Reincidencia o infracción moderada. Se limitan funciones específicas '
          '(mensajes, Marketplace, grupos) por un período de 1 a 14 días.\n\n'
          'Nivel 3 — Suspensión de cuenta:\n'
          'Infracción grave o patrón reincidente. Acceso suspendido de 1 a 30 días.\n\n'
          'Nivel 4 — Eliminación permanente:\n'
          'Infracción muy grave (doxxing, contenido sexual de menores, extorsión, '
          'reincidencia en Niveles 2-3) o cuando la presencia del usuario '
          'representa un riesgo para la comunidad.',
    ),
    LegalSection(
      id: 'bitacora',
      title: '4. Bitácora de moderación',
      body:
          'Todas las acciones de moderación se registran en una bitácora de '
          'auditoría inmutable que incluye: fecha y hora, tipo de acción, '
          'identificador del moderador, motivo y resultado.\n\n'
          'Esta bitácora se conserva durante 2 años conforme a las '
          'obligaciones legales aplicables, incluso si la cuenta del usuario '
          'implicado es eliminada.',
    ),
    LegalSection(
      id: 'apelaciones',
      title: '5. Apelación de decisiones',
      body:
          'Puedes apelar cualquier decisión de moderación dentro de los '
          '15 días hábiles siguientes a la notificación, escribiendo a '
          '${AppInfo.supportEmail} con el asunto "Apelación de moderación".\n\n'
          'La resolución de la apelación es definitiva. El equipo de Trama Campus '
          'se reserva la decisión final sobre las sanciones aplicadas.',
    ),
  ],
);

// ─────────────────────────────────────────────
// Eliminación de Cuenta y Retención
// ─────────────────────────────────────────────

final kAccountDeletionPolicy = LegalDocument(
  id: 'account_deletion',
  title: 'Eliminación de cuenta',
  icon: Icons.delete_outline,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  showArcoButton: true,
  sections: [
    LegalSection(
      id: 'intro',
      title: 'Control total sobre tus datos',
      body:
          'En Trama Campus tienes el control completo sobre tu cuenta y tus datos. '
          'Puedes desactivar o eliminar tu cuenta en cualquier momento desde '
          'Configuración → Mi cuenta → Eliminar cuenta.',
      isCallout: true,
      calloutIcon: Icons.manage_accounts_outlined,
    ),
    LegalSection(
      id: 'desactivacion',
      title: '1. Desactivación temporal',
      body:
          'Al desactivar tu cuenta:\n'
          '• Tu perfil deja de ser visible para otros usuarios de inmediato.\n'
          '• Tus listados del Marketplace se pausan automáticamente.\n'
          '• Apareces como "Cuenta inactiva" en los grupos en que eras miembro.\n'
          '• Tus datos permanecen intactos durante 30 días.\n\n'
          'Durante ese período puedes reactivar tu cuenta iniciando sesión. '
          'Transcurridos 30 días sin reactivación, la cuenta se elimina de forma definitiva.',
    ),
    LegalSection(
      id: 'eliminacion_definitiva',
      title: '2. Eliminación definitiva',
      body:
          'La eliminación definitiva ocurre:\n'
          '• Automáticamente, 30 días después de la desactivación sin reactivación.\n'
          '• De inmediato, si lo solicitas explícitamente en la pantalla de eliminación.\n\n'
          'Al ejecutarse:\n'
          '• Tu perfil, fotos, preferencias, correo y contraseña (en hash) '
          'son eliminados de la base de datos activa.\n'
          '• Tus archivos multimedia se eliminan del almacenamiento en la nube.\n'
          '• Tus vectores de compatibilidad y puntuaciones Elo se borran en cascada.\n'
          '• La puntuación visual derivada (α_global) se elimina en el siguiente '
          'proceso de mantenimiento diario.\n\n'
          'Tu UUID queda registrado como referencia vacía en la bitácora de '
          'auditoría, sin datos personales asociados, para mantener la '
          'integridad de los registros históricos.',
    ),
    LegalSection(
      id: 'datos_retenidos',
      title: '3. Datos que se conservan por obligación legal',
      body:
          'Aun después de la eliminación definitiva, conservamos ciertos datos '
          'por imperativo legal:\n\n'
          '• Bitácora de moderación: 2 años. Las acciones de moderación que te '
          'involucraron (ya sea como denunciante o denunciado) se conservan '
          'en la bitácora inmutable por este período.\n\n'
          '• Registros financieros: el historial de transacciones del Marketplace '
          'se conserva conforme a lo establecido en el Código Fiscal de la '
          'Federación (artículo 30, 5 años).',
    ),
    LegalSection(
      id: 'mensajeria',
      title: '4. Mensajería y almacenamiento local',
      body:
          'Los mensajes se almacenan en el servidor únicamente como texto '
          'cifrado durante 90 días, independientemente del estado de tu cuenta. '
          'Al eliminar tu cuenta, los mensajes son eliminados con ella.\n\n'
          'Tu dispositivo puede conservar copias locales descifradas incluso '
          'después de que el servidor las haya eliminado. Estas copias locales '
          'quedan bajo tu exclusiva responsabilidad.',
    ),
    LegalSection(
      id: 'derecho_cancelacion',
      title: '5. Tu derecho de cancelación (ARCO)',
      body:
          'La eliminación de cuenta es el ejercicio de tu derecho de Cancelación '
          'conforme al artículo 28 de la LFPDPPP. Si prefieres eliminar solo '
          'ciertos datos sin eliminar toda la cuenta, puedes ejercer el derecho '
          'de Cancelación parcial a través del formulario ARCO disponible en '
          'Configuración → Privacidad → Mis derechos ARCO.',
    ),
    LegalSection(
      id: 'como_iniciar',
      title: '6. Cómo iniciar el proceso',
      body:
          'Ve a Configuración → Mi cuenta → Eliminar cuenta.\n\n'
          'Se te pedirá indicar el motivo (para mejorar el servicio) y '
          'confirmar escribiendo "ELIMINAR". El proceso es irreversible '
          'después del período de 30 días.',
    ),
  ],
);

// ─────────────────────────────────────────────
// Cookies y Telemetría
// ─────────────────────────────────────────────

final kCookiesPolicy = LegalDocument(
  id: 'cookies_telemetry',
  title: 'Cookies y Telemetría',
  icon: Icons.data_usage_outlined,
  version: AppInfo.legalDocsVersion,
  effectiveDate: AppInfo.legalEffectiveDate,
  sections: [
    LegalSection(
      id: 'almacenamiento_local',
      title: '1. Almacenamiento local en el dispositivo',
      body:
          'Trama Campus es una aplicación móvil nativa; no utiliza cookies '
          'en el sentido web tradicional.\n\n'
          'Toda la información persistente se almacena en una base de datos '
          'SQLite local en tu dispositivo (directorio de documentos privado '
          'de la app), incluyendo tu borrador de onboarding, historial de '
          'mensajes cifrados y preferencias de la app.\n\n'
          'En esta versión MVP, los datos locales no están cifrados con una '
          'clave adicional a nivel de sistema de archivos. El sistema operativo '
          'del dispositivo provee aislamiento a nivel de sandbox de aplicación.',
      isCallout: true,
      calloutIcon: Icons.storage_outlined,
    ),
    LegalSection(
      id: 'telemetria',
      title: '2. Telemetría y análisis de uso',
      body:
          'En la versión actual de Trama Campus no recopilamos telemetría '
          'de comportamiento, eventos de uso, registros de sesión ni '
          'datos analíticos de ningún tipo que se envíen a servidores externos.\n\n'
          'Tampoco utilizamos SDK de terceros de análisis (como Firebase Analytics, '
          'Mixpanel o similar) en esta versión.',
    ),
    LegalSection(
      id: 'futuro',
      title: '3. Actualizaciones futuras',
      body:
          'Si en versiones futuras de Trama Campus introducimos telemetría, '
          'análisis de uso u otras tecnologías de seguimiento, actualizaremos '
          'esta política y el Aviso de Privacidad antes de implementarlos, '
          'y te solicitaremos consentimiento donde la ley lo requiera.',
    ),
    LegalSection(
      id: 'contacto',
      title: '4. Preguntas',
      body:
          'Para cualquier duda sobre almacenamiento local o telemetría:\n'
          '${AppInfo.privacyEmail}',
    ),
  ],
);

// ─────────────────────────────────────────────
// Índice de todos los documentos
// ─────────────────────────────────────────────

final kAllLegalDocuments = [
  kAvisoPrivacidad,
  kTermsConditions,
  kArcoRights,
  kPrivacyPolicy,
  kMarketplacePolicy,
  kSponsorsPolicy,
  kCommunityPolicy,
  kModerationPolicy,
  kAccountDeletionPolicy,
  kCookiesPolicy,
];
