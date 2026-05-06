# Trama Campus — Agent Guidelines

## Project overview

Flutter app (mobile-first, iOS + Android, dev target Linux desktop). Social matching platform for university students. Premium visual language: clean, fast, no emojis anywhere in the UI.

---

## Design system

### Typography — `AppTextStyles`

Two typefaces, strict hierarchy. Always use these helpers, never raw `TextStyle`.

| Token | Font | Size | Weight | Usage |
|---|---|---|---|---|
| `display` | Manrope | 44 | 700 | Hero screens, splash |
| `headlineLg` | Manrope | 32 | 600 | Section heroes |
| `headlineMd` | Manrope | 28 | 600 | Profile name over photo |
| `headlineSm` | Manrope | 22 | 600 | Screen titles, modal headers |
| `titleMd` | Manrope | 16 | 600 | Section labels, card titles |
| `bodyLg` | Inter | 16 | 400 | Primary body copy |
| `bodyMd` | Inter | 14 | 400 | Secondary body, descriptions |
| `bodySm` | Inter | 13 | 400 | Captions, helper text |
| `labelSm` | Inter | 12 | 500 | Chips, badges, metadata |

- Headlines use negative letter-spacing (`-0.5%` to `-2%` of size). Never add tracking to body text.
- All helpers take a `Color` argument — always pass a semantic color from `cs` (ColorScheme), not a raw hex.

### Color — `AppColors` + `ColorScheme`

Brand: **Coral red** — `#D94E2F` light / `#E87358` dark.

Always access colors via `Theme.of(context).colorScheme` (aliased as `cs`). Never hardcode `AppColors.*` constants in widgets (use them only inside theme definitions).

Key semantic roles:
- `cs.primary` — brand actions, CTA, active states
- `cs.onSurface` — primary text
- `cs.onSurfaceVariant` — secondary text, icons, labels
- `cs.surfaceContainerLowest` — card backgrounds, input fills
- `cs.outlineVariant` — borders, dividers
- `cs.primaryContainer` — tinted backgrounds (chips selected, insight badges)
- `cs.error` — destructive actions, validation errors

Ghost dividers: `AppColors.lightOutlineGhost` / `AppColors.darkOutlineGhost` (rgba ~10-12% opacity). Use these for `VerticalDivider` inside stat rows and subtle separators.

**Gradients:**
- `AppColors.ctaGradient()` — primary CTA button gradient (top-left → bottom-right)
- `AppColors.avatarGradient(hue)` — per-user hue-based gradient for avatar fallback
- CTA gradient is also used as the border on `TAvatar` when `borderWidth > 0`

### Spacing — `AppSpacing` + `AppRadius`

| Token | Value |
|---|---|
| `space1` | 4 |
| `space2` | 8 |
| `space3` | 12 |
| `space4` | 16 |
| `space5` | 20 |
| `space6` | 24 |
| `space7` | 32 |
| `space8` | 40 |
| `space9` | 48 |
| `space10` | 64 |
| `edgePadding` | 24 (= space6) |

| Radius | Value | Usage |
|---|---|---|
| `xs` | 8 | Small chips, tags |
| `sm` | 12 | Inputs, small cards |
| `md` | 16 | Standard cards, modals |
| `lg` | 24 | Large cards |
| `xl` | 32 | Bottom sheets (top corners) |
| `pill` | 999 | Fully rounded — buttons, chips, badges |

Standard screen edge padding is `AppSpacing.edgePadding` (24). Bottom of scrollable content gets `120` padding to clear the nav bar.

### Shadows — `AppColors.shadow*`

Three shadow families: `shadowAmbient*` (modals, cards), `shadowFab*` (primary action buttons with brand color glow). Always use light vs dark variants based on theme brightness.

---

## Core UI components

### `TButton`

Primary action widget. Variants: `primary` (default filled gradient), `secondary` (outlined). Never build ad-hoc buttons — always use `TButton` for actions.

- `icon` param adds a leading icon
- `onPressed: null` auto-disables with correct visual
- Full-width: wrap in `SizedBox(width: double.infinity)`

### `TChip`

Selection chip. `selected: true` fills with `cs.primary`. `onTap` for interactive, omit for display-only. Used in interests, goals, gender, modality selectors.

### `TAvatar`

- `initials` + `hue` always required (fallback when no photo)
- `photoUrl` accepts `assets/...` paths or network URLs
- `borderWidth > 0` wraps in CTA gradient ring
- Has `BoxShadow` built-in on the circle — do not add another shadow externally

### `TTextField`

Standard text input. Styled to match `InputDecorationTheme`. Use `maxLines` for multiline. Does not support `autofocus` — open keyboard manually via `FocusNode` if needed.

### `SelectionExperience`

The primary catalog picker widget (`lib/core/widgets/selection/selection_experience.dart`). Use this for every multi-item catalog selection (skills, hobbies, goals, traits, music, etc.). Never build ad-hoc chip lists for catalog domains.

Variants: `bucketed`, `chipCloud`, `traitCards`, `iconCards`, `facultyFaceted`.

Always push `SelectionExperience` as a full-screen route (via `Navigator.push`) rather than embedding it in a scrollable list to avoid nested scroll conflicts.

```dart
Navigator.push(context, MaterialPageRoute(builder: (_) =>
  _SelectionPickerPage(domain: 'skill', ...)));
```

### `StepDots`

Onboarding progress indicator. Total = **8** for the main onboarding flow. Welcome (step 0) and ProfileComplete are not counted — they don't show dots. Use `currentStep` 0-indexed (0 = Identity).

### Glass surfaces

Pattern: `ClipRRect` → `BackdropFilter(filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16))` → `Container` with `cs.surfaceContainerLowest.withValues(alpha: 0.7–0.85)`.

`AppColors.glassBlurSigma = 20.0` is the design reference; halve it (`/2`) for small pill buttons (edit button on profile hero).

---

## Layout patterns

### Hero photo screens (MyProfile, ProfileDetail)

`SliverAppBar` with `expandedHeight: 320–340`, `pinned: true`. `FlexibleSpaceBar.background` is a `Stack` with three layers (always in this order):

1. **Photo or gradient** — `Positioned.fill`, `BoxFit.cover`, `errorBuilder` falls back to `avatarGradient`
2. **Top vignette** — `LinearGradient` top→`Alignment(0, 0.1)`, `Colors.black.withValues(alpha: 0.28)` → transparent. Keeps status bar readable on any photo.
3. **Bottom fade** — `LinearGradient` transparent → `cs.surface`, stops `[0.6, 1.0]`. Merges photo into content.
4. **Text overlay** — `Positioned(bottom, left)` with name + program.

Both light and dark photos need the top vignette — without it, a white-background photo blends into the app bar.

### Bottom sheets

Use `showModalBottomSheet` with `isScrollControlled: true` to support keyboard-aware resizing. Top corners: `AppRadius.xl` (32). Grab bar: 36×4 container, `cs.outlineVariant`, `AppRadius.pill`. Padding bottom includes `MediaQuery.of(context).padding.bottom`.

Simple edits (bio, semester, single-select): use bottom sheets.  
Complex catalog pickers (5+ items): use full-screen push.

### Progress ring (edit profile)

```dart
SizedBox(
  width: 64, height: 64,
  child: CircularProgressIndicator(
    value: completionScore,
    strokeWidth: 5,
    strokeCap: StrokeCap.round,
    backgroundColor: cs.surfaceContainerHigh,
    valueColor: AlwaysStoppedAnimation(cs.primary),
  ),
)
```

Overlay the percentage label in a `Stack` centered inside.

### Edit profile — section card pattern

Each section has two states:

- **Empty**: dashed border (`BorderSide(color: cs.outlineVariant.withValues(alpha: 0.6), width: 1.5)`), "Completar" pill label, `emptyHint` text, optional impact badge (`primaryContainer.withValues(alpha: 0.45)`)
- **Filled**: solid card (`cs.surfaceContainerLowest`), preview chips, "Editar" label + `chevron_right` icon

Icon containers are 44×44, `AppRadius.sm`, colored when active (`cs.primaryContainer` bg + `cs.primary` icon), muted when empty (`cs.surfaceContainer` bg + `cs.onSurfaceVariant` icon).

---

## Onboarding flow

8 steps shown to the user (Welcome and ProfileComplete excluded from count):

| Step | Screen | Route | StepDots `currentStep` |
|---|---|---|---|
| — | Welcome | `welcome` | none |
| 1 | Identity | `identity` | 0 |
| 2 | Campus | `selectUni` | 1 |
| 3 | Email + OTP | `verifyEmail` | 2 |
| 4 | Affiliation | `affiliation` | 3 |
| 5 | Academic | `academicProfile` | 4 |
| 6 | Modality | `modalitySelect` | 5 |
| 7 | Goals | `personalGoals` | 6 |
| 8 | Skills | `skillsSelect` | 7 |
| — | Avatar | `avatarStep` | none |
| — | Profile Complete | `profileComplete` | none |

Each step saves to `OnboardingDraftRepository` before navigating forward. Drafts survive app restarts.

### Campus + program filtering

Active campuses: `kActiveCampusIds = {'UAO', 'UAXC', 'UAMN', 'UAMS', 'UAMT', 'MAYAB'}`.  
Valid programs: `isUndergradProgramId(id)` → `id.startsWith('B') || id.startsWith('I')`.  
Use `BundledCatalogRepository.instance.activeCampuses()` and `programsForCampus(campusId)` — never filter inline.

### Email validation

After campus selection, email must satisfy `CampusInfo.allowsEmail(email)` (checks `email_domains` list). Error: *"Este correo no pertenece a [campus]. Verifica o vuelve a elegir tu campus."*

### Username rules

- 3–20 chars, `[a-z0-9_]`, no leading digit or underscore
- Validated async against `MockUsernameRegistry` with debounce
- Suffix indicator: `check_circle` (available), `cancel` (taken), `CircularProgressIndicator` (checking)
- Auto-suggest on conflict: `@firstName`, `@firstName.lastName`, `@firstName_NN`

### Gender options

Identity screen: `Mujer`, `Hombre`, `Prefiero no decirlo`.  
Matching preferences: `Todos`, `Mujeres`, `Hombres` only (no "Prefiero no decirlo" here).  
No "No binario" option anywhere in the app.

---

## Data layer

- `BundledCatalogRepository` — loads JSON assets, memoized, single instance
- `OnboardingDraftRepository` — SQLite via sqflite (FFI on desktop)
- `MockData.currentUser` — demo profile for feed/explore screens
- `SelectionRelevanceEngine` — ranks catalog items by academic area, goals, modality, campus trends

### Desktop SQLite init (main.dart)

```dart
if (defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.macOS) {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

---

## Code standards

- **No emojis** anywhere — not in UI strings, not in code comments, not in CLAUDE.md
- **No co-author signatures** on commits
- No trailing `// TODO` comments left in committed code
- Prefer `cs.onSurface.withValues(alpha: x)` over deprecated `.withOpacity()`
- `errorBuilder` params: use named `(context, error, stack)`, not underscores
- String interpolation: `'$variable'` not `'${variable}'` for simple identifiers
- No `print()` in production paths — use no-op or remove
- `flutter analyze` must return 0 errors before considering a task done
- Run analyze on the individual file first (`flutter analyze lib/path/file.dart`), then full project

---

## What not to do

- Do not add features or abstractions beyond the task. A card fix does not need a refactor of the surrounding screen.
- Do not add error handling for impossible states. Trust internal invariants.
- Do not mock `SelectionExperience` with custom chip lists — use the real widget.
- Do not push to remote or create PRs without explicit user confirmation.
- Do not add comments explaining what code does — only add comments when the *why* is non-obvious.
