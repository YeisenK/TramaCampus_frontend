# Trama Campus — Engineering Handbook

## Project Overview

Trama Campus is a premium social-matching app for Mexican university students. Students sign up with an institutional email address, build an academic profile, and discover peers through one of three matching modes:

- **Estudio** — study partners, shared subjects, same semester
- **Amistad** — friendship, shared hobbies, campus activities
- **Conexión personal** — romantic or deeper personal connection

The current codebase is a fully working Flutter prototype with mock data. The architecture is intentionally simple: no state management library, no backend, no auth. Future phases will layer those in progressively.

---

## Architecture

```
lib/
  core/
    database/     # SQLite service, schema, migrations
    navigation/   # AppRouter (named routes)
    services/     # PreferencesService (meta table wrapper)
    theme/        # Design tokens (colors, typography, spacing)
    widgets/      # Reusable UI components
  data/           # Models, mock data, repositories
  features/       # One folder per product feature
  app.dart        # Root widget + theme notifier
  main.dart       # Entry point
docs/
  json-integration.md        # Backend API contract (binding)
  json-examples/             # Example payloads for each endpoint
```

### Rules

1. **Feature isolation**: Each feature folder is self-contained. A feature may import from `core/` and `data/`, but never from another feature folder directly.
2. **No business logic in widgets**: Widgets read props and call callbacks. Repositories hold data-fetching logic.
3. **Repository pattern**: Every data access goes through a repository class in `data/repositories/`. Mock implementations live there today; swap for real API calls later without touching screens.
4. **Single theme notifier**: `themeNotifier` is a global `ValueNotifier<ThemeMode>` in `app.dart`. Do not create a separate provider or package for this; it is intentionally minimal.
5. **Named routes only**: All navigation uses `Navigator.pushNamed` with `AppRouter` constants. Never call `Navigator.push(MaterialPageRoute(...))` inline — it breaks the route graph.
6. **No hardcoded colors**: Every color must come from `AppColors` (static constants) or `Theme.of(context).colorScheme`. Do not write `Color(0xFF...)` in widget files.
7. **No hardcoded text styles**: Every text style must use `AppTextStyles.*`. Do not write `TextStyle(...)` inline.

---

## UI System

### Color Tokens

Defined in `lib/core/theme/app_colors.dart`. Two palettes: light and dark. All color constants are prefixed `light` or `dark`, plus the palette-agnostic `primary`, `ctaGradient*`.

| Role | Light | Dark |
|---|---|---|
| primary | #E85A12 | #FF8A3D |
| surface | #F5F6F7 | #111314 |
| surfaceContainerLowest | #FFFFFF | #0A0C0D |
| onSurface | #2C2F30 | #E2E5E6 |
| onSurfaceVariant | #595C5D | #9EA3A5 |

`AppColors.ctaGradient()` returns the standard 135-degree orange gradient used for primary buttons, FABs, and accent elements.

`AppColors.avatarGradient(hue)` generates per-student gradient from HSL math. Use for all avatar/photo placeholders — never show a broken image state.

### Typography

Defined in `lib/core/theme/app_text_styles.dart`. Two font families:

- **Manrope** (display, headlines, titles) — loaded via `google_fonts`
- **Inter** (body, labels) — loaded via `google_fonts`

All style methods take a `Color` argument. Always pass the correct semantic color (e.g., `cs.onSurface`, not `cs.primary` for body text).

| Style | Size | Weight | Usage |
|---|---|---|---|
| display | 44px | 700 | Hero headings (Welcome screen) |
| headlineLg | 32px | 600 | Section titles |
| headlineMd | 28px | 600 | Screen titles |
| headlineSm | 22px | 600 | Card titles, profile name |
| titleMd | 16px | 600 | List item titles, button labels |
| bodyLg | 16px | 400 | Paragraph text |
| bodyMd | 14px | 400 | Secondary content |
| bodySm | 13px | 400 | Captions, helper text |
| labelSm | 12px | 500 | Tags, tab labels, timestamps |

### Spacing

All values in `lib/core/theme/app_spacing.dart`. Use `AppSpacing.space*` — never raw numbers like `const SizedBox(height: 16)`.

| Token | Value |
|---|---|
| space1 | 4 |
| space2 | 8 |
| space3 | 12 |
| space4 | 16 |
| space5 | 20 |
| space6 | 24 |
| space7 | 32 |
| space8 | 40 |
| space9 | 48 |
| space10 | 64 |
| edgePadding | 24 (alias of space6 — semantic name for screen horizontal padding) |

Border radii in `AppRadius`: xs=8, sm=12, md=16, lg=24, xl=32, pill=999.

### Shadows

Two shadow definitions (not formalized as tokens, apply inline):

```dart
// Card ambient shadow
BoxShadow(color: cs.onSurface.withValues(alpha: 0.06), blurRadius: 32, offset: Offset(0, 12)),
BoxShadow(color: cs.onSurface.withValues(alpha: 0.04), blurRadius: 12, offset: Offset(0, 4)),

// FAB / gradient button shadow
BoxShadow(color: Color(0xFFE85A12).withValues(alpha: 0.22), blurRadius: 24, offset: Offset(0, 8)),
BoxShadow(color: cs.onSurface.withValues(alpha: 0.08), blurRadius: 6, offset: Offset(0, 2)),
```

### Glass Effect

Used in bottom nav, photo area buttons, profile detail action bar. Pattern:

```dart
ClipRect(
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
    child: Container(
      color: cs.surface.withValues(alpha: 0.85),
      child: ...,
    ),
  ),
)
```

For pill-shaped glass (e.g., the feed card label): use `ClipRRect` with `BorderRadius.circular(AppRadius.pill)` instead of `ClipRect`.

---

## Core Widgets Reference

| Widget | File | Purpose |
|---|---|---|
| `TramaMark` | `core/widgets/trama_mark.dart` | Official SVG logo. `variant: markOnly` (default, trama-mark.svg) or `lockup` (logo.svg). **Always use this widget — never `Image.asset` the logo except in `splash_screen.dart`.** |
| `SafeSvg` | `core/widgets/safe_svg.dart` | `SvgPicture.asset` with `SizedBox` fallback. `TramaMark` wraps this internally. |
| `TAvatar` | `core/widgets/t_avatar.dart` | Circular gradient avatar from initials + hue |
| `TChip` | `core/widgets/t_chip.dart` | Selectable interest/filter chip |
| `TButton` | `core/widgets/t_button.dart` | CTA button (primary gradient, secondary outlined, ghost text) |
| `TTextField` | `core/widgets/t_text_field.dart` | Labeled `TextFormField` with full border styling; use in all forms |
| `StepDots` | `core/widgets/step_dots.dart` | Onboarding progress dots |
| `PhotoPlaceholder` | `core/widgets/photo_placeholder.dart` | Full-bleed gradient photo fill |
| `SegmentedControl` | `core/widgets/segmented_control.dart` | Tabbed control (Feed / Cuadrícula / Historias) |
| `ModalitySwitch` | `core/widgets/modality_switch.dart` | Horizontal scroll pill filters for modality |
| `TAppBar` | `core/widgets/t_app_bar.dart` | Themed AppBar wrapper |
| `TBottomNav` | `core/widgets/t_bottom_nav.dart` | Glass-blur bottom nav bar |
| `FeedCard` | `core/widgets/feed_card.dart` | Discovery feed item |
| `CompatibilityCard` | `core/widgets/compatibility_card.dart` | Profile detail compatibility breakdown |
| `SkeletonLoader` | `core/widgets/skeleton_loader.dart` | Animated loading skeleton |
| `EmptyState` | `core/widgets/empty_state.dart` | Centered icon + title + subtitle + optional action. Use for empty lists. |
| `ErrorState` | `core/widgets/error_state.dart` | Centered error icon + message + optional retry button. Use for failed loads. |
| `ConfirmModal` | `core/widgets/confirm_modal.dart` | `ConfirmModal.show(context, {...})` — glass-blur bottom sheet for destructive confirmations. |
| `SectionCard` | `core/widgets/section_card.dart` | Rounded container with optional header label and dividers between children. |
| `ToggleTile` | `core/widgets/toggle_tile.dart` | `ListTile` + `Switch.adaptive`. `onChanged` is nullable for disabled state. |
| `StaticTextPage` | `core/widgets/static_text_page.dart` | Scaffold + TAppBar + `ListView` of titled sections. Powers all legal/info screens. |

### TButton Variants

```dart
TButton(label: 'Conectar', onPressed: onPressed)                          // primary (gradient)
TButton(label: 'Pasar', variant: TButtonVariant.secondary, ...)           // outlined
TButton(label: 'Reenviar código', variant: TButtonVariant.ghost, ...)     // text
```

All buttons are full-width by default. Set `isFullWidth: false` for inline use.

---

## Navigation

Defined in `lib/core/navigation/app_router.dart`. All route names are static `String` constants on `AppRouter`.

### Route Map

| Route constant | Screen |
|---|---|
| `AppRouter.splash` | `SplashScreen` (initial) |
| `AppRouter.welcome` | `WelcomeScreen` |
| `AppRouter.selectUni` | `SelectUniScreen` |
| `AppRouter.verifyEmail` | `VerifyEmailScreen` |
| `AppRouter.modalitySelect` | `ModalitySelectScreen` |
| `AppRouter.academicProfile` | `AcademicProfileScreen` |
| `AppRouter.personalGoals` | `PersonalGoalsScreen` |
| `AppRouter.profileComplete` | `ProfileCompleteScreen` |
| `AppRouter.discover` | `DiscoverScreen` (main shell) |
| `AppRouter.profileDetail` | `ProfileDetailScreen` (arg: `Student`) |
| `AppRouter.matchSuccess` | `MatchSuccessScreen` (arg: `Student`) |
| `AppRouter.connections` | `ConnectionsScreen` |
| `AppRouter.chatList` | `ChatListScreen` |
| `AppRouter.conversation` | `ConversationScreen` (arg: `Student`) |
| `AppRouter.myProfile` | `MyProfileScreen` |
| `AppRouter.settingsMain` | `SettingsMainScreen` |
| `AppRouter.settingsTheme` | `SettingsThemeScreen` |
| `AppRouter.notifications` | `NotificationsScreen` |
| `AppRouter.editProfile` | `EditProfileScreen` |
| `AppRouter.accountSettings` | `AccountSettingsScreen` |
| `AppRouter.privacySettings` | `PrivacySettingsScreen` |
| `AppRouter.notificationPreferences` | `NotificationPreferencesScreen` |
| `AppRouter.securitySettings` | `SecuritySettingsScreen` |
| `AppRouter.blockedUsers` | `BlockedUsersScreen` |
| `AppRouter.deleteAccount` | `DeleteAccountScreen` |
| `AppRouter.helpCenter` | `HelpCenterScreen` |
| `AppRouter.faq` | `FaqScreen` |
| `AppRouter.contactSupport` | `ContactSupportScreen` |
| `AppRouter.reportProblem` | `ReportProblemScreen` (arg: optional `Student?`) |
| `AppRouter.termsConditions` | `TermsConditionsScreen` |
| `AppRouter.privacyPolicy` | `PrivacyPolicyScreen` |
| `AppRouter.communityGuidelines` | `CommunityGuidelinesScreen` |
| `AppRouter.about` | `AboutScreen` |

### Passing Arguments

```dart
Navigator.of(context).pushNamed(
  AppRouter.profileDetail,
  arguments: student,  // Student model
);
```

Receive in `generateRoute`:
```dart
final student = settings.arguments as Student;
```

### Bottom Navigation

`DiscoverScreen` acts as the main shell. It renders one of four tabs:
- Index 0: Discover (feed/grid/stories)
- Index 1: `ConnectionsScreen(embedded: true)`
- Index 2: `ChatListScreen(embedded: true)`
- Index 3: `MyProfileScreen(embedded: true)`

The `embedded: true` flag suppresses the leading back button on AppBars inside the shell.

---

## Data Layer

### Models

| Model | File | Key Fields |
|---|---|---|
| `Student` | `data/models/student.dart` | id, name, age, program, semester, hue, intent, bio, interests, compatibilityScore, reasons |
| `University` | `data/models/university.dart` | name, emailDomain, verified |
| `Modality` | `data/models/modality.dart` | type, label, verb, icon |
| `ChatPreview` | `data/models/chat_preview.dart` | studentId, studentName, hue, lastMessage, time, unreadCount |
| `ConversationMessage` | `data/models/conversation_message.dart` | id, text, isMe, time |
| `NotificationItem` | `data/models/notification_item.dart` | id, type, title, subtitle, time, isRead, hue |

### Mock Data

All mock data lives in `lib/data/mock/mock_data.dart` as `const` values. The current user is `MockData.currentUser` (Sofía Ramírez, hue 24). The 7 student cards, 5 chat previews, 5 conversation messages, and 4 notifications are all defined there.

When replacing mock data with real API calls:
1. Keep `MockData` as a fallback/test fixture.
2. Update the repository to call an HTTP client instead.
3. Screens do not change — they consume repository output.

### Repositories

```dart
final repo = StudentRepository();
final all = repo.getAll();
final byModality = repo.getByModality(ModalityType.estudio);
final one = repo.getById('diego');
```

---

## Onboarding Flow

6 steps, each step is a separate screen. The band header (surfaceDim bg + dot pattern) and back button are implemented via the `_OnboardingHeader` private widget inside each screen file. Step progress uses `StepDots(totalSteps: 6, currentStep: stepIndex)`.

| Step | Screen | Index |
|---|---|---|
| 1 | SelectUniScreen | 0 |
| 2 | VerifyEmailScreen | 1 |
| 3 | ModalitySelectScreen | 2 |
| 4 | AcademicProfileScreen | 3 |
| 5 | PersonalGoalsScreen | 4 |
| 6 | ProfileCompleteScreen | 5 |

The dot pattern overlay is drawn by `_DotPatternPainter` (a `CustomPainter` in `welcome_screen.dart`). If the pattern is needed on other screens, extract it to `core/widgets/`.

---

## Photo / Avatar System

No real photos. Every student has a `hue` value (0–360). Avatars and photo placeholders use:

```dart
AppColors.avatarGradient(hue)
// from: HSL(hue, 45%, 72%)
// to:   HSL((hue+30)%360, 55%, 42%)
```

Student hues:
- Ana: 20 (warm orange)
- Diego: 240 (blue)
- Renata: 320 (pink/magenta)
- Mateo: 180 (teal)
- Lucía: 120 (green)
- Javier: 60 (yellow)
- Camila: 340 (rose)
- Sofía (current user): 24

When real photo upload is added, replace `PhotoPlaceholder` with a `CachedNetworkImage` widget. The `TAvatar` widget should keep the gradient as a fallback while the image loads.

---

## Coding Standards

### File Length

Target: under 300 lines per file. If a screen grows past 300 lines, extract reusable sub-widgets into their own private classes at the bottom of the same file or into `core/widgets/`.

### Widget Const

Every widget that takes no mutable input must be `const`. Use `const` constructors everywhere possible. The analyzer will flag non-const widgets.

### Null Safety

The project is fully null-safe (`sdk: ^3.10.1`). Use `!` sparingly. If a value might be null at runtime, handle it gracefully (null check, default value, early return).

### Theme Context

Always use `Theme.of(context).colorScheme` (aliased as `cs`). Never reference `AppColors.light*` or `AppColors.dark*` directly in widget files — those are only for the `ThemeData` setup in `app_theme.dart`.

### Deprecated APIs

Use `.withValues(alpha: x)` instead of `.withOpacity(x)` for all color operations. The `withOpacity` method is deprecated in Flutter 3.x and triggers an info warning.

### Comments

No comments unless the logic is genuinely non-obvious. Self-documenting code via clear variable names and widget decomposition is preferred.

---

## Developer Rules

1. **Run `flutter analyze` before committing.** Zero errors and zero warnings required. Info-level hints should be addressed.
2. **Test with both light and dark themes** via `SettingsThemeScreen` before calling a screen done.
3. **Test all modalities** in `DiscoverScreen` — each filter (Estudio, Amistad, Conexión) must return a non-empty list from mock data.
4. **Do not add packages** without team approval. The current dependency surface is minimal by design: `google_fonts`, `flutter_svg`, `cupertino_icons`, `sqflite`, `path_provider`, `path`. No new packages without explicit approval.
5. **Do not add features beyond the design spec** — Trama Campus is scope-locked to the 18 screens in this prototype phase.
6. **Asset directories** (`assets/images/`, `assets/svg/`) exist but are currently empty (`.gitkeep`). Add assets to the correct folder and reference them via `AssetImage` or `SvgPicture.asset`.

---

## Future Integration Notes

### Authentication

The app currently has no auth. When Supabase (or equivalent) is added:
- Add an `AuthRepository` under `data/repositories/`.
- Gate `DiscoverScreen` behind an auth check in `app.dart` or a redirect in `AppRouter`.
- The `VerifyEmailScreen` already has the UI for email + OTP; wire it to the auth service.

### Real-time Chat

`ConversationScreen` uses a local list of `ConversationMessage` objects. Replace with a stream-backed list from Supabase Realtime or Firebase. The UI bubble logic does not change.

### Push Notifications

`NotificationsScreen` reads from `MockData.notifications`. Connect to FCM (Firebase Cloud Messaging) or APNs via the `flutter_local_notifications` package. The `NotificationItem` model already supports the three notification types: match, request, group.

### Photo Upload

`ProfileCompleteScreen` and `MyProfileScreen` have edit buttons wired to `() {}`. When photo upload is implemented:
- Use `image_picker` to select from camera/gallery.
- Upload to Supabase Storage or Firebase Storage.
- Replace `PhotoPlaceholder` with a `CachedNetworkImage` with the gradient as placeholder.

### Analytics

Add `firebase_analytics` or `posthog_flutter`. Key events to track:
- `onboarding_step_completed` (step 1–6)
- `modality_selected`
- `profile_viewed` (with student_id)
- `match_initiated`
- `match_success`
- `chat_opened`

### Localization

All UI strings are currently hardcoded in Spanish. When multi-language support is needed, extract strings to `.arb` files using Flutter's `flutter_localizations` package. The app is Spanish-first; do not introduce an `l10n` layer until there is a concrete need for a second language.

---

## Local Persistence (SQLite)

SQLite is used for two things: profile photo storage (future) and app preferences.

### Bootstrap order

`main.dart` awaits `DatabaseService.instance.database` before `runApp`. Screens must never call `DatabaseService` directly — use the repository layer.

### Migration rule

Every schema change requires a new `Migration` entry in `lib/core/database/migrations.dart`. The top-level assert `kMigrations.last.version == kDatabaseVersion` in `database_service.dart` fails fast if a version bump was missed.

### `meta` table

Reserved for app-level key/value preferences (e.g., theme mode). Access only through `PreferencesService.instance`. Do not write raw SQL against `meta` from feature code.

### Key files

| File | Purpose |
|---|---|
| `lib/core/database/database_service.dart` | Singleton; lazy `Future<Database>`; runs migrations |
| `lib/core/database/schema.dart` | Table and column name constants — no stringly-typed SQL |
| `lib/core/database/migrations.dart` | `Migration` class + `kMigrations` list |
| `lib/core/services/preferences_service.dart` | Typed wrapper over `meta` table for app prefs |
| `lib/data/models/local_profile_photo.dart` | Profile photo model with `fromMap`/`toMap` |
| `lib/data/repositories/profile_photo_repository.dart` | Abstract interface + SQLite implementation |

---

## Stability Rules

1. **`if (!mounted) return;` after every `await` in async navigation handlers.** Any method that calls `Navigator.*` or shows a `SnackBar` after an `await` must check `mounted` first.
2. **Every controller must be disposed.** `TextEditingController`, `AnimationController`, `ScrollController` — all disposed in `dispose()`.
3. **Every list view must handle three states: loading, empty, error.** Use `SkeletonLoader` for loading, `EmptyState` for empty, `ErrorState` for errors. Never show a blank screen.

---

## JSON Integration Contract

The binding contract between the Flutter app and the backend API is documented in `docs/json-integration.md`. It covers:

- Modality mapping (Flutter 3 modes → backend 13 modes)
- Full profile schema with validation rules
- Matching request/response format (mirrors [`matching_service/Docs/matching_input.md`](../../Trama_back/matching_service/Docs/matching_input.md))
- Chat WebSocket event shapes
- FCM push notification payloads
- All settings endpoints and JSON keys

**Do not define API contracts inline in feature code.** All schemas live in `docs/json-integration.md`.

---

## Key File Locations

| Purpose | Path |
|---|---|
| Color palette | `lib/core/theme/app_colors.dart` |
| Text styles | `lib/core/theme/app_text_styles.dart` |
| Spacing/radius | `lib/core/theme/app_spacing.dart` |
| Theme data | `lib/core/theme/app_theme.dart` |
| Router | `lib/core/navigation/app_router.dart` |
| Mock data | `lib/data/mock/mock_data.dart` |
| Current user | `MockData.currentUser` in mock_data.dart |
| Theme mode | `themeNotifier` in `lib/app.dart` |
| Entry point | `lib/main.dart` |
