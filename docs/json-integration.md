# Contrato de Integración JSON — Trama Campus

> **Última sincronización con backend:** 2026-05-05  
> **Versión de contrato:** 1.1  
> **Referencia canónica del backend:** [`matching_service/Docs/matching_input.md`](../../Trama_back/matching_service/Docs/matching_input.md)

Este documento define el contrato de integración entre el cliente Flutter y los servicios backend de Trama Campus. Cubre el esquema de perfil, el protocolo de matching, el modelo de chat, las notificaciones y los ajustes de usuario.

---

## Índice

1. [Resumen](#1-resumen)
2. [Mapeo de modalidades](#2-mapeo-de-modalidades)
3. [Esquema de usuario y perfil](#3-esquema-de-usuario-y-perfil)
4. [Datos de matching](#4-datos-de-matching)
5. [Modo Estudio](#5-modo-estudio)
6. [Modo Amistad](#6-modo-amistad)
7. [Modo Conexión personal](#7-modo-conexión-personal)
8. [Chats y mensajería](#8-chats-y-mensajería)
9. [Notificaciones](#9-notificaciones)
10. [Ajustes y preferencias](#10-ajustes-y-preferencias)
11. [Marketplace](#11-marketplace)
12. [Grupos](#12-grupos)
13. [Catálogos referenciados](#13-catálogos-referenciados)
14. [Reglas de validación](#14-reglas-de-validación)
15. [Compatibilidad futura](#15-compatibilidad-futura)
16. [Apéndice — Glosario](#16-apéndice--glosario)

---

## 1. Resumen

### Propósito

Documenta el contrato entre la app Flutter (`trama_campus_frontend`) y el API Gateway de Trama Campus, para que el equipo backend pueda definir los endpoints REST/WebSocket que la app consumirá en la fase de integración.

### Alcance

| Capa | Estado |
|------|--------|
| Autenticación (JWT/OAuth) | Fuera del alcance de este documento |
| Perfil y onboarding | Cubierto — sección 3 |
| Motor de matching | Cubierto — secciones 4–7 |
| Chat en tiempo real | Cubierto — sección 8 |
| Notificaciones push | Cubierto — sección 9 |
| Ajustes y privacidad | Cubierto — sección 10 |
| Catálogos estáticos | Cubierto — sección 11 |

### Dirección del contrato

La app Flutter es el **cliente consumidor**. Los esquemas JSON de este documento representan los payloads que la app espera enviar y recibir. El backend debe cumplir este contrato; cambios que rompan la compatibilidad requieren versionar el endpoint.

---

## 2. Mapeo de modalidades

La app Flutter expone **3 modalidades** al usuario. El motor de matching del backend opera sobre **13 modalidades** (`modality_enum` en el esquema `campus_users.preferences.modes`).

> ⚠ **[REQUIERE CONFIRMACIÓN]** El mapeo siguiente es la propuesta del equipo frontend. El equipo de producto debe confirmar antes de que se indexen usuarios en producción.

| Modalidad Flutter | `ModalityType` (Dart) | Modalidades backend (`modes[]`) |
|---|---|---|
| Estudio | `estudio` | `study`, `research`, `competition` |
| Amistad | `amistad` | `social`, `networking`, `gaming`, `language`, `creative`, `volunteer`, `wellness`, `lifestyle`, `startup` |
| Conexión personal | `personal` | `eros` |

### Lógica de envío desde la app

Cuando el usuario selecciona una modalidad en la pantalla de onboarding o edita su perfil:

```json
{
  "ui_modality": "estudio",
  "modes": ["study", "research", "competition"]
}
```

El campo `ui_modality` es informativo para logging/analytics. El backend usa `modes[]` como fuente de verdad para el motor de matching.

### Hard filter de modalidad

El backend aplica un hard filter: si `modes_A ∩ modes_B = ∅`, el par no se genera.  
Ver: [`matching_input.md §2.3 f_mod`](../../Trama_back/matching_service/Docs/matching_input.md#f_mod--modalidades-activas)

---

## 3. Esquema de usuario y perfil

### 3.1 Perfil base (`profiles`)

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "display_name": "Sofía Ramírez",
  "first_name": "Sofía",
  "last_name": "Ramírez",
  "bio": "Apasionada por el diseño UX y la accesibilidad digital.",
  "avatar_url": "https://cdn.tramacampus.mx/avatars/550e8400.jpg",
  "birth_date": "2002-03-14",
  "age": 24,
  "gender": "F",
  "gender_preference": "M",
  "career_id": "uuid-ingenieria-computacion",
  "semester": 6,
  "university_id": "uuid-universidad",
  "hue": 210.0,
  "is_verified": true,
  "created_at": "2025-08-01T14:22:00Z",
  "updated_at": "2026-05-04T09:15:00Z"
}
```

| Campo | Tipo | Requerido | Validación | Pantalla fuente |
|-------|------|-----------|-----------|-----------------|
| `id` | `UUID` | Sí | Generado por backend | — |
| `display_name` | `string` | Sí | 2–50 caracteres | Editar perfil |
| `first_name` | `string` | Sí | 2–30 caracteres | Onboarding |
| `last_name` | `string` | Sí | 2–30 caracteres | Onboarding |
| `bio` | `string` | No | Máx. 300 caracteres; ≥ 20 para `f_prof` | Editar perfil |
| `avatar_url` | `string (URL)` | No | URL válida HTTPS; +2× en `f_prof` | Editar perfil |
| `birth_date` | `string (ISO 8601)` | Sí | Edad 17–35 años | Onboarding |
| `age` | `integer` | Calculado | ≥ 17 | — |
| `gender` | `string` | Sí | `"M"`, `"F"`, `"NB"`, `"prefer_not_say"` | Onboarding |
| `gender_preference` | `string` | Sí | `"M"`, `"F"`, `"NB"`, `"any"` | Onboarding |
| `career_id` | `UUID` | Sí | FK a catálogo `careers` | Onboarding |
| `semester` | `integer` | Sí | 1–12 | Onboarding / Editar perfil |
| `university_id` | `UUID` | Sí | FK a catálogo `universities` | Onboarding |
| `hue` | `float` | Calculado | 0.0–360.0; derivado de `career_id` | — |
| `is_verified` | `boolean` | Sí | Requiere email institucional | Verificar correo |

### 3.2 Preferencias (`preferences`)

```json
{
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "modes": ["study", "research"],
  "ui_modality": "estudio",
  "goals": ["aprender_nuevas_habilidades", "preparar_examen"],
  "skills": ["python", "figma", "diseño_ux", "sql"],
  "research_interests": ["hci", "accesibilidad"],
  "available_days": ["mon_am", "mon_pm", "wed_am", "fri_pm"],
  "connectivity_state": "active",
  "lifestyle_context": null,
  "commute_origin_zone": null,
  "commute_transport": null,
  "commute_schedule": null,
  "roomie_zones": null,
  "roomie_rent_range": null,
  "roomie_start_date": null
}
```

| Campo | Tipo | Requerido | Validación | Pantalla fuente |
|-------|------|-----------|-----------|-----------------|
| `modes` | `string[]` | Sí | ≥ 1 elemento; valores del enum `modality_enum` | Onboarding / Editar perfil |
| `ui_modality` | `string` | Sí | `"estudio"`, `"amistad"`, `"personal"` | Discover (switch) |
| `goals` | `string[]` | Sí | ≥ 1, ≤ 15; valores del catálogo `goals` | Onboarding |
| `skills` | `string[]` | Sí | 3–50 elementos; valores del catálogo `skills` | Onboarding / Editar perfil |
| `research_interests` | `string[]` | No | 0–8 elementos; catálogo `research_topics` | Editar perfil |
| `available_days` | `string[]` | Condicional | 21 combinaciones `{día}_{turno}`; activo si `study` ∈ `modes` | Onboarding |
| `connectivity_state` | `string` | Sí | `"active"`, `"paused"`, `"invisible"` | Ajustes de privacidad |

### 3.3 Atributos de perfil (`profile_attributes`)

Estructura polimórfica — cada registro tiene `attribute_type` y `value`.

```json
[
  { "attribute_type": "hobby",            "value": "fotografía" },
  { "attribute_type": "hobby",            "value": "senderismo" },
  { "attribute_type": "sport",            "value": { "sport": "basketball", "frequency": "regular" } },
  { "attribute_type": "personality_trait","value": "curioso" },
  { "attribute_type": "personality_trait","value": "organizado" },
  { "attribute_type": "language",         "value": { "lang": "en", "level": "advanced" } },
  { "attribute_type": "language",         "value": { "lang": "fr", "level": "intermediate" } },
  { "attribute_type": "diet",             "value": "vegetariano" },
  { "attribute_type": "music_genre",      "value": "indie" },
  { "attribute_type": "music_genre",      "value": "jazz" }
]
```

| `attribute_type` | `value` schema | Límite | Catálogo |
|---|---|---|---|
| `hobby` | `string` | ≤ 10 | `hobbies` |
| `sport` | `{ sport: string, frequency: "casual" \| "regular" \| "competitive" }` | ≤ 5 | `sports` |
| `personality_trait` | `string` | ≤ 5; default `[curioso, colaborador, reflexivo]` | `personality_traits` |
| `language` | `{ lang: string (BCP-47), level: "basic" \| "intermediate" \| "advanced" \| "native" }` | ≤ 15 | ISO 639-1 |
| `diet` | `string` | ≤ 3 | `{omnivoro, vegetariano, vegano, sin_gluten, halal, kosher, sin_lactosa}` |
| `music_genre` | `string` | ≤ 4 | `music_genres` |

---

## 4. Datos de matching

### 4.1 Sugerencias (feed de discover)

```
GET /v1/discover/suggestions?modality=study&limit=20&cursor=<opaque>
Authorization: Bearer <jwt>
```

**Respuesta:**

```json
{
  "items": [
    {
      "user_id": "uuid-b",
      "display_name": "Carlos Mendoza",
      "first_name": "Carlos",
      "age": 22,
      "career": "Ingeniería en Sistemas",
      "semester": 7,
      "bio": "Fanático del open source y los hackathons.",
      "avatar_url": "https://cdn.tramacampus.mx/avatars/uuid-b.jpg",
      "hue": 180.0,
      "interests": ["python", "linux", "hackathons"],
      "compatibility_score": 74,
      "compatibility_reasons": ["Misma área académica", "Habilidades complementarias", "Disponibilidad coincide"],
      "shared_modes": ["study"],
      "is_saved": false
    }
  ],
  "next_cursor": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "has_more": true
}
```

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `compatibility_score` | `integer` (0–100) | `s(A,B) × 100`, redondeado |
| `compatibility_reasons` | `string[]` | ≤ 3 razones legibles en español |
| `shared_modes` | `string[]` | Intersección `modes_A ∩ modes_B` |
| `is_saved` | `boolean` | Estado de guardado del usuario actual |
| `next_cursor` | `string` | Cursor opaco para paginación |

### 4.2 Acción sobre sugerencia

```
POST /v1/discover/action
Authorization: Bearer <jwt>

{
  "target_user_id": "uuid-b",
  "action": "like",
  "modality": "study"
}
```

| `action` | Descripción |
|----------|-------------|
| `like` | Me gusta — actualiza Elo y `f_recip` |
| `pass` | Pasar — el par no vuelve a aparecer en 30 días |
| `save` | Guardar para después — sin efecto en Elo |
| `unsave` | Quitar de guardados |

**Respuesta cuando hay match mutuo:**

```json
{
  "matched": true,
  "match_id": "uuid-match",
  "conversation_id": "uuid-conv",
  "elo_delta": 18
}
```

### 4.3 Score on-demand (interno)

Ver [`matching_input.md §5`](../../Trama_back/matching_service/Docs/matching_input.md#5-payload-http-on-demand-opcional).

```
POST /internal/matching/score
Authorization: Service-Token <token-interno>

{
  "user_a": "uuid-a",
  "user_b": "uuid-b",
  "modality": "study",
  "options": {
    "include_vector_rebuild": false,
    "include_dimension_breakdown": true
  }
}
```

Ver `docs/json-examples/matching-score-response.json` para la respuesta completa.

---

## 5. Modo Estudio

Corresponde a `ui_modality = "estudio"` → `modes ∩ {study, research, competition}`.

### Campos específicos requeridos

| Campo | Tabla | Obligatorio para |
|-------|-------|-----------------|
| `preferences.skills` | `campus_users.preferences` | `study`, `research`, `competition` |
| `preferences.research_interests` | `campus_users.preferences` | `research` |
| `preferences.available_days` | `campus_users.preferences` | `study` |

### Factores activos del score

| Factor | Peso en S_acad | Condición |
|--------|---------------|-----------|
| `f_carr` | 0.30 | Siempre |
| `f_sem` | 0.20 | Siempre |
| `f_skill` | 0.20 | Siempre |
| `f_res` | 0.10 | Solo si `research` ∈ `modes_A ∩ modes_B` |
| `f_idioma` | 0.10 | Siempre |
| `f_hora` | 0.10 | Solo si `study` ∈ `modes_A ∩ modes_B` |

### UI ↔ backend: pantalla de disponibilidad

La app muestra un selector de días/turnos. Cada celda marcada produce un elemento en `available_days`:

| Turno app | Sufijo backend | Horas aproximadas |
|-----------|---------------|-------------------|
| Mañana | `_am` | 07:00–13:00 |
| Tarde | `_pm` | 13:00–19:00 |
| Noche | `_eve` | 19:00–23:00 |

Ejemplo: lunes mañana + miércoles tarde → `["mon_am", "wed_pm"]`.

---

## 6. Modo Amistad

Corresponde a `ui_modality = "amistad"` → `modes ∩ {social, networking, gaming, language, creative, volunteer, wellness, lifestyle, startup}`.

### Submodalidades y contexto

| Submodalidad | Descripción | Campos extra |
|---|---|---|
| `social` | Actividades sociales y ocio | — |
| `networking` | Conexiones profesionales | `goals` orientados a carrera |
| `gaming` | Videojuegos y esports | Atributo `hobby` con valor de juego |
| `language` | Intercambio de idiomas | `profile_attributes` con `language` nivel ≥ `intermediate` |
| `creative` | Arte, música, diseño | `profile_attributes` tipo `hobby` creativo |
| `volunteer` | Voluntariado y servicio social | `goals` orientados a impacto |
| `wellness` | Bienestar físico y mental | `profile_attributes` tipo `sport` o `hobby` wellness |
| `lifestyle` | Commute o roomie compartido | `lifestyle_context`, campos de commute/roomie |
| `startup` | Emprendimiento | `goals` orientados a startup |

### `lifestyle_context` — Commute / Roomie

Solo activo si el usuario declara `lifestyle` en `modes`:

```json
{
  "lifestyle_context": "commute",
  "commute_origin_zone": "norte",
  "commute_transport": "metro",
  "commute_schedule": "mon_am"
}
```

```json
{
  "lifestyle_context": "roomie",
  "roomie_zones": ["roma_norte", "condesa", "narvarte"],
  "roomie_rent_range": { "min": 4000, "max": 7000, "currency": "MXN" },
  "roomie_start_date": "2026-08-01"
}
```

---

## 7. Modo Conexión personal

Corresponde a `ui_modality = "personal"` → `modes = ["eros"]`.

> ⚠ Esta modalidad solo está disponible para usuarios ≥ 18 años verificados.

### Campos requeridos adicionales

| Campo | Tabla | Requerido |
|-------|-------|-----------|
| `profiles.gender` | `campus_users.profiles` | Sí (`"M"`, `"F"`, `"NB"`) |
| `profiles.gender_preference` | `campus_users.profiles` | Sí |
| `profiles.avatar_url` | `campus_users.profiles` | Sí (sin foto → `α_global = 0.0`) |

### Fórmula S_eros

Cuando `eros ∈ modes_A ∩ modes_B`, el score total usa pesos distintos:

```
s(A,B) = 0.28·S_acad + 0.20·S_pers + 0.20·S_int + 0.12·S_behav + 0.20·S_eros
```

Ver [`matching_input.md §2.5`](../../Trama_back/matching_service/Docs/matching_input.md#25-dimensión-de-atracción--s_eros-condicional) para la fórmula completa de `S_eros`.

### Score de atractivo (`α_global`)

- Calculado automáticamente por `matching-ml` sidecar al subir foto con `eros` activo.
- Solo el escalar `α ∈ [0,1]` se persiste en `campus_matching.eros_profile_data`.
- La app **no recibe** este valor — es interno al motor de matching.

---

## 8. Chats y mensajería

### 8.1 Lista de conversaciones

```
GET /v1/conversations?limit=30&cursor=<opaque>
Authorization: Bearer <jwt>
```

**Respuesta:**

```json
{
  "items": [
    {
      "id": "uuid-conv-1",
      "match_id": "uuid-match-1",
      "other_user": {
        "id": "uuid-b",
        "display_name": "Carlos Mendoza",
        "first_name": "Carlos",
        "avatar_url": "https://cdn.tramacampus.mx/avatars/uuid-b.jpg",
        "hue": 180.0,
        "is_online": true
      },
      "last_message": {
        "id": "uuid-msg-99",
        "text": "¡Claro! El martes en la biblioteca está perfecto.",
        "sender_id": "uuid-b",
        "sent_at": "2026-05-04T10:31:00Z",
        "read_at": null
      },
      "unread_count": 2,
      "created_at": "2026-04-20T18:00:00Z"
    }
  ],
  "next_cursor": "eyJ...",
  "has_more": false
}
```

El modelo Dart `ChatPreview` mapea a este esquema:

| Campo Dart | Campo JSON |
|---|---|
| `studentId` | `other_user.id` |
| `studentName` | `other_user.display_name` |
| `hue` | `other_user.hue` |
| `lastMessage` | `last_message.text` |
| `time` | `last_message.sent_at` (formateado localmente) |
| `unreadCount` | `unread_count` |

### 8.2 Mensajes de una conversación

```
GET /v1/conversations/{conversation_id}/messages?limit=50&before=<message_id>
Authorization: Bearer <jwt>
```

**Respuesta:**

```json
{
  "items": [
    {
      "id": "uuid-msg-100",
      "conversation_id": "uuid-conv-1",
      "sender_id": "uuid-a",
      "text": "¿Estudiamos juntos esta semana?",
      "sent_at": "2026-05-04T10:30:00Z",
      "read_at": "2026-05-04T10:31:00Z",
      "edited_at": null,
      "deleted": false
    }
  ],
  "has_more": true,
  "oldest_id": "uuid-msg-1"
}
```

El modelo Dart `ConversationMessage` mapea:

| Campo Dart | Campo JSON |
|---|---|
| `id` | `id` |
| `text` | `text` |
| `isMe` | `sender_id == currentUser.id` |
| `time` | `sent_at` (formateado localmente) |

### 8.3 Enviar mensaje

```
POST /v1/conversations/{conversation_id}/messages
Authorization: Bearer <jwt>

{
  "text": "¿Estudiamos juntos esta semana?",
  "client_id": "uuid-generado-en-cliente"
}
```

`client_id` es un UUID generado en el cliente para deduplicar envíos.

### 8.4 WebSocket — stream en tiempo real

```
WS wss://api.tramacampus.mx/v1/ws
Authorization: Bearer <jwt>  (header o query param ?token=<jwt>)
```

**Eventos del servidor → cliente:**

```json
{ "type": "message.new",       "data": { ...ConversationMessage... } }
{ "type": "message.read",      "data": { "conversation_id": "...", "read_at": "..." } }
{ "type": "typing.start",      "data": { "conversation_id": "...", "user_id": "..." } }
{ "type": "typing.stop",       "data": { "conversation_id": "...", "user_id": "..." } }
{ "type": "presence.online",   "data": { "user_id": "...", "last_seen": null } }
{ "type": "presence.offline",  "data": { "user_id": "...", "last_seen": "2026-05-04T10:35:00Z" } }
{ "type": "match.new",         "data": { "match_id": "...", "conversation_id": "...", "user": {...} } }
```

**Eventos cliente → servidor:**

```json
{ "type": "typing.start",  "conversation_id": "uuid-conv-1" }
{ "type": "typing.stop",   "conversation_id": "uuid-conv-1" }
{ "type": "message.read",  "conversation_id": "uuid-conv-1", "message_id": "uuid-msg-100" }
```

Ver `docs/json-examples/chat-message-stream.json` para ejemplos completos.

---

## 9. Notificaciones

### 9.1 Lista de notificaciones

```
GET /v1/notifications?limit=30&cursor=<opaque>
Authorization: Bearer <jwt>
```

**Respuesta:**

```json
{
  "items": [
    {
      "id": "uuid-notif-1",
      "type": "match",
      "title": "¡Nuevo match!",
      "subtitle": "Tú y Carlos Mendoza son compatibles en Estudio",
      "action_url": "/conversations/uuid-conv-1",
      "actor": {
        "id": "uuid-b",
        "display_name": "Carlos Mendoza",
        "avatar_url": "https://cdn.tramacampus.mx/avatars/uuid-b.jpg",
        "hue": 180.0
      },
      "is_read": false,
      "created_at": "2026-05-04T10:30:00Z"
    }
  ],
  "unread_count": 3,
  "next_cursor": "eyJ...",
  "has_more": false
}
```

El modelo Dart `NotificationItem` mapea:

| Campo Dart | Campo JSON |
|---|---|
| `id` | `id` |
| `type` | `type` → `NotificationType` |
| `title` | `title` |
| `subtitle` | `subtitle` |
| `time` | `created_at` (formateado localmente) |
| `isRead` | `is_read` |
| `hue` | `actor.hue` |

| `type` backend | `NotificationType` Dart |
|---|---|
| `match` | `NotificationType.match` |
| `connection_request` | `NotificationType.request` |
| `group_invite` | `NotificationType.group` |
| `task_assigned` | `NotificationType.group` (pendiente tipo propio) |
| `message` | (pendiente en modelo Dart) |

### 9.2 Payload FCM (push)

```json
{
  "notification": {
    "title": "¡Nuevo match!",
    "body": "Tú y Carlos Mendoza son compatibles en Estudio"
  },
  "data": {
    "type": "match",
    "notification_id": "uuid-notif-1",
    "action_url": "/conversations/uuid-conv-1",
    "actor_id": "uuid-b",
    "actor_name": "Carlos Mendoza",
    "actor_hue": "180.0"
  },
  "android": { "priority": "high" },
  "apns": { "headers": { "apns-priority": "10" } }
}
```

El campo `data.type` debe tener un valor del enum: `match`, `connection_request`, `group_invite`, `message`.

Ver `docs/json-examples/notification-push-payload.json` para todos los tipos.

### 9.3 Marcar como leída

```
PATCH /v1/notifications/{id}/read
Authorization: Bearer <jwt>
```

```
PATCH /v1/notifications/read-all
Authorization: Bearer <jwt>
```

---

## 10. Ajustes y preferencias

Todos los ajustes se persisten en el backend y se leen al arrancar la app. Localmente se guardan en la tabla `meta` de SQLite como caché para acceso sin red.

### 10.1 Ajustes de privacidad

```
GET/PATCH /v1/settings/privacy
Authorization: Bearer <jwt>
```

```json
{
  "profile_visibility": "everyone",
  "contact_permission": "matches_only",
  "show_last_seen": true,
  "show_online_status": true,
  "show_semester": true,
  "show_career": true,
  "show_interests": true,
  "share_interests_with_matches": true,
  "connectivity_state": "active"
}
```

| Campo | Valores | Pantalla Flutter |
|-------|---------|-----------------|
| `profile_visibility` | `"everyone"`, `"university"`, `"matches_only"` | Privacidad → Visibilidad del perfil |
| `contact_permission` | `"everyone"`, `"matches_only"`, `"nobody"` | Privacidad → ¿Quién puede contactarme? |
| `show_last_seen` | `boolean` | Privacidad → Mostrar última conexión |
| `show_online_status` | `boolean` | Privacidad → Mostrar estado en línea |
| `show_semester` | `boolean` | Privacidad → Mostrar semestre |
| `show_career` | `boolean` | Privacidad → Mostrar carrera |
| `show_interests` | `boolean` | Privacidad → Mostrar intereses |
| `share_interests_with_matches` | `boolean` | Privacidad → Compartir intereses |
| `connectivity_state` | `"active"`, `"paused"`, `"invisible"` | Privacidad (sección `δ_con`) |

### 10.2 Preferencias de notificación

```
GET/PATCH /v1/settings/notifications
Authorization: Bearer <jwt>
```

```json
{
  "push_enabled": true,
  "matches": true,
  "connection_requests": true,
  "messages": true,
  "group_invites": true,
  "study_reminders": false,
  "weekly_digest": true,
  "email_notifications": false
}
```

| Campo | Descripción | Pantalla Flutter |
|-------|-------------|-----------------|
| `push_enabled` | Master toggle de push | Notificaciones → Notificaciones push |
| `matches` | Nuevos matches | Notificaciones → Nuevas coincidencias |
| `connection_requests` | Solicitudes de conexión | Notificaciones → Solicitudes de conexión |
| `messages` | Mensajes nuevos | Notificaciones → Mensajes |
| `group_invites` | Invitaciones a grupos | Notificaciones → Grupos de estudio |
| `study_reminders` | Recordatorios de sesión | Notificaciones → Recordatorios de estudio |
| `weekly_digest` | Resumen semanal | Notificaciones → Resumen semanal |
| `email_notifications` | Notificaciones por correo | (pendiente en UI) |

### 10.3 Ajustes de seguridad

```
GET /v1/settings/security
Authorization: Bearer <jwt>
```

```json
{
  "two_factor_enabled": false,
  "biometrics_enabled": false,
  "active_sessions": [
    {
      "id": "uuid-session-1",
      "device_name": "iPhone 15",
      "last_active": "2026-05-04T09:00:00Z",
      "is_current": true
    }
  ]
}
```

```
POST /v1/auth/change-password
Authorization: Bearer <jwt>

{ "current_password": "...", "new_password": "..." }
```

```
DELETE /v1/settings/security/sessions/{session_id}
Authorization: Bearer <jwt>
```

### 10.4 Eliminar cuenta

```
POST /v1/account/delete
Authorization: Bearer <jwt>

{
  "reason": "no_lo_uso",
  "confirmation": "ELIMINAR"
}
```

| `reason` | Etiqueta en app |
|----------|----------------|
| `no_lo_uso` | Ya no uso la app |
| `privacidad` | Preocupaciones de privacidad |
| `encontre_lo_que_buscaba` | Encontré lo que buscaba |
| `mala_experiencia` | Mala experiencia |
| `otro` | Otro motivo |

La cuenta se desactiva inmediatamente; los datos se eliminan en 30 días conforme a la política de privacidad.

### 10.5 Usuarios bloqueados

```
GET /v1/settings/blocked-users
Authorization: Bearer <jwt>
```

```json
{
  "items": [
    {
      "id": "uuid-block-1",
      "blocked_user_id": "uuid-x",
      "blocked_user_name": "Usuario",
      "blocked_at": "2026-04-01T12:00:00Z"
    }
  ]
}
```

```
POST /v1/settings/blocked-users
{ "target_user_id": "uuid-x" }

DELETE /v1/settings/blocked-users/{user_id}
```

---

## 11. Marketplace

### 11.1 Listados (feed de exploración)

```
GET /v1/marketplace/listings?category=<category>&variant=editorial&limit=20&cursor=<opaque>
Authorization: Bearer <jwt>
```

`category` es opcional. Valores: `apuntes`, `servicios`, `articulos`, `freelance`. Sin categoría devuelve todos.

**Respuesta:**

```json
{
  "items": [
    {
      "id": "uuid-listing-1",
      "title": "Apuntes Cálculo III — Parcial completo",
      "description": "Incluye todos los temas del parcial 2, ejercicios resueltos paso a paso.",
      "price": 120.0,
      "category": "apuntes",
      "type": "student_listing",
      "is_boosted": true,
      "is_affiliate": false,
      "seller": {
        "id": "uuid-seller",
        "display_name": "Diego Navarro",
        "avatar_url": null,
        "hue": 60.0
      },
      "image_urls": ["https://cdn.tramacampus.mx/listings/uuid-listing-1/1.jpg"],
      "published_at": "2026-04-30T10:00:00Z"
    }
  ],
  "next_cursor": "eyJ...",
  "has_more": true
}
```

El modelo Dart `MarketplaceListing` mapea:

| Campo Dart | Campo JSON |
|---|---|
| `id` | `id` |
| `title` | `title` |
| `description` | `description` |
| `price` | `price` |
| `category` | `category` → `ListingCategory` |
| `isBoosted` | `is_boosted` |
| `isAffiliate` | `is_affiliate` |
| `sellerName` | `seller.display_name` |
| `sellerAvatarUrl` | `seller.avatar_url` |
| `imageUrls` | `image_urls` |
| `publishedAt` | `published_at` |

### 11.2 Empresas afiliadas

```
GET /v1/marketplace/affiliates
Authorization: Bearer <jwt>
```

**Respuesta:**

```json
{
  "items": [
    {
      "id": "uuid-biz-1",
      "name": "Copias Campus",
      "service_type": "copyshop",
      "promotions": ["20% dto para estudiantes Anáhuac"],
      "logo_url": null,
      "is_verified": true
    }
  ]
}
```

`service_type` valores: `restaurant`, `gym`, `salon`, `copyshop`, `laundry`, `tutoring`, `brand`, `rental`.

### 11.3 Publicar listado

```
POST /v1/marketplace/listings
Authorization: Bearer <jwt>

{
  "title": "Apuntes Cálculo III",
  "description": "Parcial completo con ejercicios resueltos.",
  "price": 120.0,
  "category": "apuntes",
  "image_urls": []
}
```

El `PublishSheet` de la app genera este payload. El campo `is_boosted` lo gestiona el backend (false por defecto). El campo `seller` se deduce del JWT.

**Respuesta (éxito):**

```json
{ "id": "uuid-listing-nuevo", "published_at": "2026-05-05T14:30:00Z" }
```

Ver `docs/json-examples/marketplace-listings-response.json` para ejemplos completos.

---

## 12. Grupos

### 12.1 Descubrir grupos

```
GET /v1/groups?kind=<kind>&limit=20&cursor=<opaque>
Authorization: Bearer <jwt>
```

`kind` es opcional. Valores: `project`, `study`, `club`, `sport`, `official`.

**Respuesta:**

```json
{
  "items": [
    {
      "id": "g1",
      "name": "Hackathon Nacional · Equipo C",
      "tagline": "Equipo cerrado · Ing. de Software · entrega 14 nov",
      "kind": "project",
      "access": "invite",
      "verified": false,
      "featured": true,
      "hue": 60.0,
      "member_count": 4,
      "capacity": 5,
      "activity": "Activo · ahora",
      "next_action": "Sprint hoy 19:00 · Lab Cómputo",
      "leader": "Javier Cortés",
      "description": "Equipo formado para el Hackathon Nacional 2025.",
      "is_member": true
    }
  ],
  "next_cursor": "eyJ...",
  "has_more": false
}
```

El modelo Dart `Group` mapea directamente a snake_case ↔ camelCase. El campo `is_member` indica si el usuario autenticado ya pertenece al grupo (usado para el badge "Unido" en `GroupCard`).

| `kind` | `GroupKind` Dart |
|---|---|
| `project` | `GroupKind.project` |
| `study` | `GroupKind.study` |
| `club` | `GroupKind.club` |
| `sport` | `GroupKind.sport` |
| `official` | `GroupKind.official` |

| `access` | `GroupAccess` Dart |
|---|---|
| `open` | `GroupAccess.open` |
| `request` | `GroupAccess.request` |
| `invite` | `GroupAccess.invite` |

### 12.2 Detalle de grupo

```
GET /v1/groups/{group_id}
Authorization: Bearer <jwt>
```

Respuesta: objeto `Group` individual (mismo esquema que un ítem de la lista), sin cursor/paginación.

### 12.3 Tareas del grupo (tablero)

```
GET /v1/groups/{group_id}/tasks?status=<status>
Authorization: Bearer <jwt>
```

`status` opcional. Valores: `todo`, `in_progress`, `done`.

**Respuesta:**

```json
{
  "items": [
    {
      "id": "t1",
      "code": "HKT-12",
      "title": "Diseñar onboarding de la app",
      "status": "in_progress",
      "assignee": {
        "id": "uuid-camila",
        "display_name": "Camila R.",
        "avatar_url": null,
        "hue": 340.0
      },
      "due": "2026-11-14",
      "priority": "high",
      "created_at": "2026-11-01T10:00:00Z"
    }
  ]
}
```

| `status` backend | `TaskStatus` Dart |
|---|---|
| `todo` | `TaskStatus.todo` |
| `in_progress` | `TaskStatus.inProgress` |
| `done` | `TaskStatus.done` |

| `priority` backend | `TaskPriority` Dart |
|---|---|
| `low` | `TaskPriority.low` |
| `med` | `TaskPriority.med` |
| `high` | `TaskPriority.high` |

### 12.4 Crear tarea

```
POST /v1/groups/{group_id}/tasks
Authorization: Bearer <jwt>

{
  "title": "Nueva tarea",
  "assignee_id": "uuid-miembro",
  "due": "2026-11-20",
  "priority": "med"
}
```

El código (`code`) lo genera el backend con el prefijo del grupo (ej. `HKT-16`).

### 12.5 Actualizar estado de tarea

```
PATCH /v1/groups/{group_id}/tasks/{task_id}
Authorization: Bearer <jwt>

{ "status": "done" }
```

### 12.6 Crear grupo

```
POST /v1/groups
Authorization: Bearer <jwt>

{
  "name": "Filosofía de la mente",
  "tagline": "Lectura y discusión · martes 18:00",
  "description": "Grupo de lectura interdisciplinar.",
  "kind": "study",
  "access": "open"
}
```

El creador queda como líder automáticamente. `hue` se asigna por el backend según el `kind` + hash del `id`.

**Respuesta:**

```json
{ "id": "g8", "name": "Filosofía de la mente", "created_at": "2026-05-05T15:00:00Z" }
```

### 12.7 Solicitar ingreso

```
POST /v1/groups/{group_id}/join
Authorization: Bearer <jwt>
```

Para `access = "open"`: ingreso inmediato, devuelve `{ "joined": true }`.  
Para `access = "request"`: solicitud pendiente, devuelve `{ "requested": true }`.  
Para `access = "invite"`: error 403 — solo por invitación.

### 12.8 Miembros del grupo

```
GET /v1/groups/{group_id}/members
Authorization: Bearer <jwt>
```

```json
{
  "items": [
    {
      "user_id": "uuid-javier",
      "display_name": "Javier Cortés",
      "role": "leader",
      "avatar_url": null,
      "hue": 60.0,
      "joined_at": "2026-10-01T00:00:00Z"
    }
  ]
}
```

`role` valores: `leader`, `member`.

Ver `docs/json-examples/group-list-response.json` y `group-tasks-response.json` para ejemplos completos.

---

## 13. Catálogos referenciados

### 13.1 Catálogos locales bundled (fase prototipo)

Mientras no existe API de catálogos, la app lee los JSONs desde `assets/catalogs/`. Hay dos grupos:

**`assets/catalogs/_derived/`** — derivados del backend, regenerar con `tool/sync_catalogs.py` + `tool/translate_catalogs.py`. Nunca editar a mano.

| Archivo | Catálogo | Notas |
|---|---|---|
| `academic.json` | Carreras por área | Estructura especial: campo `areas` en lugar de `sets` |
| `campus.json` | Sedes universitarias | Incluye `alias` y `city`; `id` = código de campus |
| `goal.json` | Objetivos | Sets + subsets + items |
| `hobby.json` | Pasatiempos | Sets + subsets (vacíos) + items |
| `music_genre.json` | Géneros musicales | Sets + items |
| `personality_trait.json` | Rasgos de personalidad | Items en español, no requiere traducción |
| `research_interest.json` | Intereses de investigación | Solo activos si `research ∈ modes` |
| `skill.json` | Habilidades | Sets + items; mínimo 3 requeridos |
| `sport.json` | Deportes | Sets + items |

**`assets/catalogs/_frontend/`** — authorizados por el equipo frontend. Editar directamente si es necesario.

| Archivo | Catálogo | Notas |
|---|---|---|
| `diet.json` | Dieta | 7-enum fijo del backend; sin sets |
| `language.json` | Idiomas | BCP-47 ids |
| `available_days.json` | Disponibilidad | 21 combinaciones `{día}_{turno}` |
| `modality.json` | Modalidades | 13 modos backend derivados del `diet_catalog.json` del backend (mislabeled) |

**Esquema común de catálogo bundled:**

```json
{
  "catalog": "skill",
  "version": "2026-05-04",
  "sets": [
    { "id": "software_and_technology", "label": "Software y Tecnología", "subsets": [] }
  ],
  "items": [
    { "id": "web development", "label": "Desarrollo Web", "sets": ["software_and_technology"], "subsets": [] }
  ]
}
```

El campo `id` de cada item es el valor que se guarda en el perfil y se envía al backend. Siempre en minúsculas.

### 13.2 API de catálogos remota (fase integración)

Los catálogos son datos semi-estáticos. La app los descarga al primer arranque y los refresca si `version` cambia.

```
GET /v1/catalogs/{catalog_name}?version=<cached_version>
Authorization: Bearer <jwt>
```

Si la versión no ha cambiado: `304 Not Modified`. Si cambió: `200` con el catálogo completo.

| `catalog_name` | Descripción | TTL sugerido |
|---|---|---|
| `academic` | Carreras universitarias con `area` | 24 h |
| `campus` | Sedes universitarias con `alias` y `city` | 48 h |
| `skills` | Habilidades técnicas y blandas | 12 h |
| `hobbies` | Actividades de ocio | 12 h |
| `sports` | Deportes | 12 h |
| `research_interests` | Temas de investigación | 24 h |
| `personality_traits` | Rasgos de personalidad | 24 h |
| `music_genres` | Géneros musicales | 48 h |
| `goals` | Objetivos declarados | 24 h |

El esquema de respuesta remota debe ser compatible con el esquema bundled (§13.1) para que `BundledCatalogRepository` pueda reemplazarse por un `RemoteCatalogRepository` sin cambiar los consumidores.

---

## 14. Reglas de validación

| Campo | Regla | Efecto si no se cumple |
|-------|-------|----------------------|
| `bio` | Máx. 300 caracteres; ≥ 20 para bonus `f_prof` | Puntaje `f_prof` reducido |
| `skills` | 3–50 elementos | `f_skill` calculado con señal reducida si < 3 |
| `hobbies` | ≤ 10 elementos | Sin efecto en matching |
| `personality_traits` | ≤ 5 elementos | Default `[curioso, colaborador, reflexivo]` si vacío |
| `languages` | Máx. 15 idiomas; español excluido del cálculo | Sin efecto (español universal) |
| `diet` | Máx. 3 valores | Sin efecto en matching |
| `music_genres` | Máx. 4 géneros | Sin efecto en matching |
| `sports` | Máx. 5 deportes; solo `regular`/`competitive` cuentan | `f_dep` reducido |
| `modes` | ≥ 1 modo activo | Usuario no aparece en sugerencias (hard filter) |
| `semester` | 1–12 | `f_sem` incorrecto |
| `age` | 17–35 años al registrarse | Registro rechazado |
| `available_days` | Subconjunto de 21 combinaciones `{día}_{turno}` | `f_hora = 0.0` si vacío |
| `goals` | ≥ 1, ≤ 15 | `f_goal` reducido |
| `research_interests` | 0–8 elementos | `f_res = 0.0` si vacío |
| `display_name` | 2–50 caracteres | Perfil incompleto → `f_prof` reducido |
| `avatar_url` | URL HTTPS válida | Pierde 2× en `f_prof`; `α_global = 0.0` |

---

## 15. Compatibilidad futura

### Versionado de API

- Versión actual: `/v1/`
- Cambios que rompen compatibilidad requieren incrementar a `/v2/`
- La app verifica `X-API-Min-Version` en cada respuesta y muestra un aviso de actualización si la versión instalada es inferior

### Cambios en v1.1 (actual)

| Área | Cambio |
|------|--------|
| Marketplace | Nuevos endpoints `/v1/marketplace/listings` y `/v1/marketplace/affiliates` (secciones 11.1–11.3) |
| Grupos | Nuevo recurso `/v1/groups` con sub-recursos tasks y members (secciones 12.1–12.8) |
| Notificaciones | `group_invite` ya documentado; `data.type` ahora debe soportar también `task_assigned` |

### Campos probables en v2

| Campo | Motivo | Impacto en app |
|-------|--------|----------------|
| `modes` | Agregar `gaming` con Elo propio (dim 11 actualmente ocupada por `eros`) | Requiere actualizar `ModalityType` o subtipos |
| `lifestyle_context` | Expansión a más subcontextos (coworking, viaje) | Nueva UI en editar perfil |
| `research_interests` | Pasar de `TEXT[]` a objetos estructurados con relevancia | Parser de catálogo actualizado |
| `bio` | Aumentar límite a 500 caracteres | Actualizar validación en cliente |
| `available_days` | Granularidad de hora específica (no solo turno) | Rediseño del selector de disponibilidad |
| `groups.tasks` | Agregar sub-tareas y comentarios inline (Linear-style) | Nuevo componente `TaskDetailSheet` |

### Campos que permanecerán estables

- `id` (UUID), `modes`, `skills`, `semester`, `career_id`, `gender`, `gender_preference`
- Estructura de `breakdown` en respuesta de score
- Tipos de notificación: `match`, `connection_request`, `group_invite`, `message`
- Esquema de `Group` (id, name, kind, access, hue, member_count)
- Esquema de `Task` (id, code, title, status, assignee, due, priority)

---

## 16. Apéndice — Glosario

| Término | Definición |
|---------|-----------|
| `α_global` | Score de atractivo de perfil calculado por `matching-ml`; escalar ∈ [0,1] |
| `cold_start` | Usuario con < 50 interacciones Elo; su vector no se indexa en HNSW |
| `connectivity_state` | Estado visible del usuario (`active`, `paused`, `invisible`); controla `δ_con` |
| `δ_con` | Multiplicador de conectividad en `S_int`; 1.0 si activo, < 1.0 si pausado, 0 si invisible |
| `Elo` | Sistema de rating adaptativo para medir popularidad relativa por modalidad |
| `f_act` | Factor de actividad reciente basado en días desde último login |
| `f_prof` | Factor de completitud de perfil; suma ponderada de 12 campos (foto vale 2×) |
| `f_recip` | Factor de reciprocidad: ratio likes dados / recibidos en 30 días |
| `f_resp` | Factor de respuesta: conversaciones respondidas en 72h / recibidas en 30 días |
| `HNSW` | Hierarchical Navigable Small World — índice vectorial ANN para búsqueda eficiente |
| `η_elo` | Rating Elo normalizado por modalidad mediante función sigmoide; ∈ [0,1] |
| `modes` | Array de submodalidades backend activas para un usuario; mapea a `ui_modality` en la app |
| `modality_enum` | Enum PostgreSQL con 13 valores: `study`, `research`, `competition`, `social`, `networking`, `gaming`, `language`, `creative`, `volunteer`, `wellness`, `lifestyle`, `startup`, `eros` |
| `ρ_par` | Similitud coseno entre embeddings visuales de dos usuarios; calcula atracción recíproca |
| `s(A,B)` | Score de compatibilidad entre usuarios A y B; ∈ [0,1] |
| `S_acad` | Dimensión académica del score; peso 0.35 en modo general |
| `S_eros` | Dimensión de atracción; solo activa si `eros ∈ modes_A ∩ modes_B` |
| `S_int` | Dimensión de intención (modalidades + objetivos + lifestyle + Elo); peso 0.25 |
| `S_pers` | Dimensión personal (hobbies, deportes, personalidad, dieta, música); peso 0.25 |
| `S_behav` | Dimensión conductual (actividad, perfil, respuesta, reciprocidad); peso 0.15 |
| `ui_modality` | Modalidad seleccionada en la UI Flutter (`estudio`, `amistad`, `personal`) |
| `v_u` | Vector de usuario en ℝ⁶⁴ para el índice HNSW; 5 bloques: Elo, Académico, Personal, Intención, Conductual |
