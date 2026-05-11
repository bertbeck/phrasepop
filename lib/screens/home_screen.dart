import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:primio_app/models/phrase.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/bouncy_button.dart';
import 'package:primio_app/widgets/common/neon_background.dart';
import 'package:primio_app/widgets/common/neon_label.dart';
import 'package:primio_app/widgets/home/category_chip.dart';
import 'package:primio_app/widgets/home/daily_phrase_card.dart';

/// Home screen — entry point after splash.
///
/// Layout (top → bottom):
///   • Header bar (logo text + avatar)
///   • Logo hero image
///   • Giant glowing PLAY button
///   • Category selector chips
///   • Daily Phrase card
///   • Random phrase shortcut
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PhraseCategory? _selected;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: NeonBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar ────────────────────────────────────────────────
                const _TopBar()
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.2, end: 0),

                const SizedBox(height: AppTheme.spacingMd),

                // ── Logo ───────────────────────────────────────────────────
                Center(
                  child: Image.asset(
                    'assets/images/phrasepop_logo.png',
                    width: 180,
                    fit: BoxFit.contain,
                  )
                      .animate(delay: 100.ms)
                      .scale(
                        begin: const Offset(0.85, 0.85),
                        end: const Offset(1.0, 1.0),
                        curve: Curves.elasticOut,
                        duration: 700.ms,
                      ),
                ),

                const SizedBox(height: AppTheme.spacingLg),

                // ── PLAY button ────────────────────────────────────────────
                _GlowPlayButton(
                  onTap: () => context.push('/game', extra: _selected),
                ).animate(delay: 200.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                      duration: 700.ms,
                    ),

                const SizedBox(height: AppTheme.spacingXl),

                // ── Categories ─────────────────────────────────────────────
                NeonLabel('Choose a Category', accentColor: appColors.cyan)
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: AppTheme.spacingMd),

                Wrap(
                  spacing: AppTheme.spacingSm,
                  runSpacing: AppTheme.spacingSm,
                  children: PhraseCategory.values.map((cat) {
                    return CategoryChip(
                      category: cat,
                      isSelected: _selected == cat,
                      onTap: () => setState(
                        () => _selected = _selected == cat ? null : cat,
                      ),
                    );
                  }).toList(),
                ).animate(delay: 350.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppTheme.spacingLg),

                // ── Daily phrase card ──────────────────────────────────────
                DailyPhraseCard(onTap: () => context.push('/game'))
                    .animate(delay: 450.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.15, end: 0),

                const SizedBox(height: AppTheme.spacingMd),

                // ── Random shortcut ────────────────────────────────────────
                BouncyButton(
                  label: 'Random Phrase 🎲',
                  icon: Icons.shuffle_rounded,
                  variant: BouncyButtonVariant.secondary,
                  onPressed: () => context.push('/game'),
                ).animate(delay: 550.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppTheme.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  // Auth / profile features are disabled for v1 release.
  // The avatar button is intentionally hidden; it will be re-enabled
  // in a future release when account creation and login are supported.
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PhrasePop',
              style: textTheme.headlineSmall?.copyWith(
                foreground: Paint()
                  ..shader = AppTheme.primaryGradient.createShader(
                    const Rect.fromLTWH(0, 0, 160, 40),
                  ),
              ),
            ),
            Text(
              "Let's pop some phrases! 🫧",
              style: textTheme.bodySmall?.copyWith(color: appColors.subtleText),
            ),
          ],
        ),
        // Hidden for v1 — will be restored when auth is enabled.
        const SizedBox(width: 42, height: 42),
      ],
    );
  }
}

// ─── Play button ───────────────────────────────────────────────────────────────

/// Large circular gradient PLAY button with glow shadow and bounce.
class _GlowPlayButton extends StatefulWidget {
  final VoidCallback onTap;

  const _GlowPlayButton({required this.onTap});

  @override
  State<_GlowPlayButton> createState() => _GlowPlayButtonState();
}

class _GlowPlayButtonState extends State<_GlowPlayButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              // Outer animated glow pulse
              BoxShadow(
                color: appColors.primaryPurple.withValues(
                  alpha: 0.25 + _pulse.value * 0.25,
                ),
                blurRadius: 40 + _pulse.value * 20,
                spreadRadius: 8 + _pulse.value * 6,
              ),
              // Inner tight glow
              BoxShadow(
                color: appColors.cyan.withValues(alpha: 0.2),
                blurRadius: AppTheme.glowBlurSm,
              ),
            ],
          ),
          child: child,
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow_rounded, size: 58, color: Colors.white),
                Text(
                  'PLAY',
                  style: text.labelLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
