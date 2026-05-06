# trama_campus_frontend

Flutter frontend for Trama Campus — social-matching app for Mexican university students. Three match modes: Estudio, Amistad, Conexión personal.

**Current state:** fully working prototype with mock data, complete Trama Campus 2 visual redesign applied (Phases 1–8). No backend, no auth, no real state management.

---

## Setup

```bash
flutter pub get
flutter run
```

Requires Flutter SDK `^3.41.0`. Targets mobile (iOS/Android). Portrait-only — locked in `main.dart`.

---

## Project structure

```
lib/
  core/
    database/     # SQLite service, schema, migrations
    navigation/   # AppRouter (named routes)
    services/     # PreferencesService (meta table wrapper)
    theme/        # Design tokens (colors, typography, spacing)
    widgets/
      selection/  # MultiSelectChipsField, CatalogPickerSheet, etc. — do not touch
  data/
    mock/         # MockData constants
    models/
      catalog/    # Catalog, CatalogItem, CatalogSet
      group.dart  # Group, GroupKind, GroupAccess
      task.dart   # Task, TaskStatus, TaskPriority
      profile/    # Profile, ProfileBase, Preferences, ProfileDraft, ProfileAttribute
    repositories/ # StudentRepository, BundledCatalogRepository, OnboardingDraftRepository, …
    services/     # ModalityResolver, ProfileValidator
  features/
    chat/         # ChatListScreen, ConversationScreen
    connections/  # ConnectionsScreen, MatchSuccessScreen
    discover/     # DiscoverScreen (feed/grid/stories variants), FeedCard, DiscoverVariantSwitch
    groups/       # GroupsDiscoverScreen, GroupDetailScreen, CreateGroupSheet
    marketplace/  # MarketplaceScreen (editorial/list/grid), PublishSheet, featured strip, cards
    notifications/
    onboarding/
    profile/
    settings/
  app.dart        # root widget, global themeNotifier
  main.dart       # entry point
assets/
  catalogs/
    _derived/     # backend-derived JSONs — never edit manually (re-run tool/sync_catalogs.py)
    _frontend/    # frontend-authored JSONs (diet, modality, available_days, language)
  images/
  svg/
tool/
  sync_catalogs.py      # derives _derived/ from backend source JSONs
  translate_catalogs.py # applies Spanish label translations to _derived/
docs/
  json-integration.md   # backend API contract (binding)
  json-examples/        # example payloads for each endpoint
```

Features can import from `core/` and `data/` but never from each other.

---

## Running / testing

```bash
flutter analyze       # must be zero errors before committing
flutter test          # 135 tests across 8 phases
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

## Design tokens (Trama Campus 2)

Brand hue corrected in Phase 1 from saturated amber (`#E85A12`) to refined coral (`#D94E2F`).

| Role | Light | Dark |
|---|---|---|
| primary / ctaGradientStart | `#D94E2F` | `#E87358` |
| surface | `#F5F6F7` | `#111314` |
| surfaceContainerLowest | `#FFFFFF` | `#0A0C0D` |
| onSurface | `#2C2F30` | `#E2E5E6` |
| glassBlurSigma | `20.0` | `20.0` |
| glassSaturationBoost | `1.2` | `1.2` |

`AppColors.ctaGradient()` — 135° gradient, `#D94E2F` → `#E87358`.  
`AppColors.avatarGradient(hue)` — per-student HSL gradient placeholder.  
`AppColors.lightGlassBg` / `darkGlassBg` — semi-transparent fill for glass surfaces.  
`AppColors.lightOutlineGhost` / `darkOutlineGhost` — rgba 12% border for ghost dividers.

---

## Core widgets

| Widget | File | Purpose |
|---|---|---|
| `TGlassAppBar` | `core/widgets/t_glass_app_bar.dart` | Sticky glass app bar (blur σ=20, 1px ghost border) |
| `TThemeToggle` | `core/widgets/t_theme_toggle.dart` | 36×36 glass pill — light/dark toggle |
| `NetworkTexture` | `core/widgets/network_texture.dart` | Dotted network pattern (CustomPainter); use at 4–6% opacity |
| `THeroScaffold` | `core/widgets/t_hero_scaffold.dart` | Reusable 320px hero photo header with scrim and back button |
| `TScheduleGrid` | `core/widgets/t_schedule_grid.dart` | 7×8 availability heat-map (free / maybe / busy) |
| `TSegmentedUnderline` | `core/widgets/t_segmented_underline.dart` | Underline-style tab bar (2px primary active border) |
| `TGrabBar` | `core/widgets/t_grab_bar.dart` | 4×36px modal grab handle — prepend to all bottom sheets |
| `TButton` | `core/widgets/t_button.dart` | CTA button with `TButtonSize` enum (xs/sm/md/lg) |
| `TChip` | `core/widgets/t_chip.dart` | Pill chip with `TChipSize` (regular/small) |
| `TAppBar` | `core/widgets/t_app_bar.dart` | Non-glass app bar for settings sub-pages |
| `TBottomNav` | `core/widgets/t_bottom_nav.dart` | Glass bottom nav — 5 tabs, inactive labels hidden |
| `FeedCard` | `core/widgets/feed_card.dart` | Discovery feed card with glass overlays |
| `TAvatar` | `core/widgets/t_avatar.dart` | Circular gradient avatar |
| `SkeletonLoader` | `core/widgets/skeleton_loader.dart` | Shimmer loading skeleton |

The `core/widgets/selection/` system (SelectionExperience, MultiSelectChipsField, etc.) is complete and stable — do not modify.

---

## Hard rules

- No hardcoded colors — use `AppColors.*` or `Theme.of(context).colorScheme`
- No hardcoded text styles — use `AppTextStyles.*`
- No hardcoded spacing — use `AppSpacing.space*`
- Named routes only — `Navigator.pushNamed` + `AppRouter` constants, never inline `MaterialPageRoute`
- Use `.withValues(alpha: x)` not `.withOpacity(x)` (deprecated in Flutter 3.x)
- No new packages without team approval (current: `google_fonts`, `flutter_svg`, `cupertino_icons`, `sqflite`, `path_provider`, `path`)

---

## Navigation

Bottom nav has **5 tabs** (in order): Descubrir / Conexiones / Market / Chats / Perfil.

Screens embedded in the shell pass `embedded: true` to suppress the back button.

### Route argument types

| Route constant | Argument type |
|---|---|
| `AppRouter.profileDetail` | `Student` |
| `AppRouter.matchSuccess` | `Student` |
| `AppRouter.conversation` | `Student` |
| `AppRouter.listingDetail` | `MarketplaceListing` |
| `AppRouter.affiliateDetail` | `AffiliateBusiness` |
| `AppRouter.reservation` | `AffiliateBusiness` |
| `AppRouter.groupDetail` | `Group` |
| `AppRouter.reportProblem` | `Student?` |

Full route map is in `agents.md`.

---

## Features

### Discover
Three view variants (feed / grid / stories) toggled by `DiscoverVariantSwitch`. Modality switcher sits above. Default variant: feed.

### Marketplace
Editorial layout with featured strip (boosted listings), variant switcher (Editorial / Lista / Grid), stats bar, and gradient FAB. Publishing flow is a bottom sheet (`PublishSheet`) using `TGrabBar`.

### Groups
New module (Phase 8). Groups are surfaced from the Connections tab ("Descubrir grupos" entry). Screens: `GroupsDiscoverScreen` → `GroupDetailScreen` (Tablero / Miembros / Acerca de tabs). Crear via `CreateGroupSheet`. Groups are **not** a navbar tab — accessed through Connections and Profile.

### Chat
Glass composer with `BackdropFilter` σ=20. Own bubbles use brand gradient; other bubbles use `surfaceContainerLowest`.

---

## Data layer

Everything goes through a repository in `data/repositories/`. Screens don't touch `MockData` directly. When the backend is added, swap the repository implementation — screens don't change.

---

See `agents.md` for the full engineering handbook (UI system, widget reference, coding standards).  
See `docs/json-integration.md` for the backend API contract.
