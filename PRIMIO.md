# PhrasePop

## Overview
A premium hypercasual word/phrase guessing game where players uncover hidden phrases for maximum points. Visual identity driven by the PhrasePop logo — neon bubbles, purple/cyan gradients, and glossy arcade aesthetics. Fully playable offline with local phrase data; prepared for optional Golang + Postgres backend.

## Tech Stack & Key Decisions
- **BLoC/Cubit** for game state only (`GameCubit`); screens that don't need state use plain `StatefulWidget`
- **GoRouter** with route-scoped `BlocProvider` — `GameCubit` is wired in the `/game` route builder, not globally
- **Dark-only theme** — `AppTheme.darkTheme` is the single ThemeData; no light theme exists (brand requires dark neon)
- **`AppColors` ThemeExtension** holds all brand colors; widgets access via `Theme.of(context).extension<AppColors>()!`
- **`AppTheme` gradients** (`primaryGradient`, `secondaryGradient`, `accentGradient`, `successGradient`, `dangerGradient`) are `const` `LinearGradient` fields on `AppTheme` — import once, use anywhere
- **`google_fonts` Poppins** — ExtraBold/800 for headings to match logo's thick rounded typography
- **Local phrase data only** for MVP; `PhraseRepository` is static const — no async, no loading states needed

## Architecture
- Feature-based screens in `lib/screens/`; feature modules in `lib/features/<name>/` (data / cubit / presentation); shared widgets in `lib/widgets/common/`
- Screens are thin orchestrators — they read the Cubit and compose extracted widget classes
- No `_build*()` methods anywhere; every visual group is its own `StatelessWidget`/`StatefulWidget`
- `GameCubit` → `GameService` → `PhraseRepository` is the only game data flow chain
- `SplashCubit` → `SplashPreferences` (SharedPreferences) handles launch count + hide-splash logic
- `AuthService` and `ApiClient` are scaffolded but not wired to any state management (MVP mock only)

## Conventions
- All colors from `appColors.*` or `colorScheme.*` — never `Colors.*` in widget files
- All gradients from `AppTheme.*Gradient` — never inline `LinearGradient` in widget files
- All spacing from `AppTheme.spacing*`, radii from `AppTheme.radius*`, glow from `AppTheme.glowBlur*`
- Neon glow shadow pattern: `BoxShadow(color: color.withValues(alpha: AppTheme.opacityGlow), blurRadius: AppTheme.glowBlurMd)`
- New card surfaces → `NeonCard` widget; new backgrounds → `NeonBackground` widget
- New buttons → `BouncyButton` with `BouncyButtonVariant` enum (primary/secondary/ghost)
- Section headings → `NeonLabel`; feedback messages → `FeedbackBanner` with `FeedbackType`

## Key Patterns & Gotchas
- `NeonCard` uses a `CustomPainter` (`_NeonBorderPainter`) to draw a gradient stroke — this avoids the layout issues that `BoxDecoration.border` has with gradients
- `PhraseDisplay` letter tiles animate via `AnimationController` in `_LetterTileState`; the flip triggers in `didUpdateWidget` when `revealed` flips from false → true
- `ConfettiOverlay` is pure `CustomPainter` — no extra packages needed; particles spawn from bottom-center on `active: true`
- **Intro page dual-gate**: `SplashScreen` only navigates when BOTH the 3-second animation timer AND `SplashCubit.initialize()` have completed — neither alone triggers navigation
- **Intro routing**: `SplashPreferences.shouldShowIntro` checks `hideSplash` first, then `launchCount > kMaxIntroLaunches (3)`; `incrementLaunchCount` is called BEFORE the check so the count is current
- **Intro on `/intro` route**: a fresh `SplashCubit` is provided in the route builder so the intro page is self-contained for deep-linking and testing; it does NOT re-increment the count
- The `foreground: Paint()..shader` trick on the `PhrasePop` title text creates the gradient text effect without any package

## Design System
- **Primary palette**: Purple `#7B3FF2` → Cyan `#35D6FF` (logo's main gradient direction: top-left → bottom-right)
- **Background**: `#0E1022` (near-black deep navy) — never use `Colors.black` directly
- **Card surfaces**: `#1A1F3A` with subtle top-left lighter gradient (`#1E2448`) for depth
- **Glow convention**: every interactive element has a matching `BoxShadow` glow at `AppTheme.opacityGlow` (0.35) alpha
- **Typography**: Poppins w800/w900 for headings; all `labelLarge` buttons are w700 with `letterSpacing: 0.5`
