# trama_campus_frontend

Flutter frontend for Trama Campus — social-matching app for Mexican university students. Three match modes: Estudio, Amistad, Conexión personal.

**Current state:** fully working prototype with mock data. No backend, no auth, no real state management.

---

## Setup

```bash
flutter pub get
flutter run
```

Requires Flutter SDK `^3.10.1`. Targets mobile (iOS/Android). Portrait-only — locked in `main.dart`.

---

## Project structure

```
lib/
  core/           # theme, router, shared widgets
  data/           # models, mock data, repositories
  features/       # one folder per feature
    chat/
    connections/
    discover/
    notifications/
    onboarding/
    profile/
    settings/
  app.dart        # root widget, global themeNotifier
  main.dart       # entry point
assets/
  images/         # currently empty (.gitkeep)
  svg/            # currently empty (.gitkeep)
```

Features can import from `core/` and `data/` but never from each other.

---

## Running / testing

```bash
flutter analyze       # must be zero errors before committing
flutter test
```

Always test both light and dark themes via Settings > Appearance before marking a screen done.

---

## Key files

| What | Where |
|---|---|
| Colors | `lib/core/theme/app_colors.dart` |
| Text styles | `lib/core/theme/app_text_styles.dart` |
| Spacing / radius | `lib/core/theme/app_spacing.dart` |
| Theme data | `lib/core/theme/app_theme.dart` |
| Router + route constants | `lib/core/navigation/app_router.dart` |
| All mock data | `lib/data/mock/mock_data.dart` |
| Current mock user | `MockData.currentUser` (Sofía Ramírez, hue 24) |
| Theme mode notifier | `themeNotifier` in `lib/app.dart` |

---

## Hard rules

- No hardcoded colors — use `AppColors.*` or `Theme.of(context).colorScheme`
- No hardcoded text styles — use `AppTextStyles.*`
- No hardcoded spacing — use `AppSpacing.space*`
- Named routes only — `Navigator.pushNamed` + `AppRouter` constants, never inline `MaterialPageRoute`
- Use `.withValues(alpha: x)` not `.withOpacity(x)` (deprecated in Flutter 3.x)
- No new packages without team approval (current: `google_fonts`, `flutter_svg`, `cupertino_icons`)
- No features outside the 18-screen prototype spec

---

## Navigation

`DiscoverScreen` is the main shell (bottom nav with 4 tabs). Screens embedded in the shell get `embedded: true` to suppress the back button.

Route args: `profileDetail` and `matchSuccess` take a `Student`, `conversation` takes a `Student`.

Full route map is in `agents.md`.

---

## Data layer

Everything goes through a repository in `data/repositories/`. Screens don't touch `MockData` directly. When the backend is added, swap the repository implementation — screens don't change.

---

## Pending integrations (not started)

- **Auth** — Supabase, gate via `AppRouter`, wire `VerifyEmailScreen` OTP
- **Real-time chat** — replace local message list with Supabase Realtime stream
- **Push notifications** — FCM/APNs via `flutter_local_notifications`
- **Photo upload** — `image_picker` + Supabase/Firebase Storage, replace `PhotoPlaceholder`
- **Analytics** — track onboarding steps, modality selection, match events, chat opens

---

See `agents.md` for the full engineering handbook (UI system, widget reference, coding standards).
