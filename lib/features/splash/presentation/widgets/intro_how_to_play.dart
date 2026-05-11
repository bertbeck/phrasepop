import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primio_app/features/splash/presentation/widgets/intro_step_tile.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/neon_card.dart';
import 'package:primio_app/widgets/common/neon_label.dart';

/// The "How to Play" section rendered inside the intro page.
///
/// Includes:
/// - A brief game description NeonCard
/// - A NeonLabel section heading
/// - Four IntroStepTile widgets with staggered entrance animations
class IntroHowToPlay extends StatelessWidget {
  const IntroHowToPlay({super.key});

  // ── Step definitions ────────────────────────────────────────────────────────
  static const List<_Step> _steps = [
    _Step(
      text: 'Read the category clue.',
      icon: Icons.lightbulb_outline_rounded,
      gradient: AppTheme.accentGradient,
    ),
    _Step(
      text: 'Guess the hidden word or phrase.',
      icon: Icons.edit_rounded,
      gradient: AppTheme.primaryGradient,
    ),
    _Step(
      text: 'Reveal more letters when you need help.',
      icon: Icons.visibility_rounded,
      gradient: AppTheme.secondaryGradient,
    ),
    _Step(
      text: 'Solve faster to earn more points!',
      icon: Icons.bolt_rounded,
      gradient: AppTheme.successGradient,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Game description card ─────────────────────────────────────────
        NeonCard(
          borderGradient: AppTheme.accentGradient,
          glowColor: appColors.magenta,
          borderOpacity: 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Decorative bubble icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: appColors.magenta.withValues(
                        alpha: AppTheme.opacityGlow,
                      ),
                      blurRadius: AppTheme.glowBlurSm,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bubble_chart_rounded,
                  color: Colors.white,
                  size: AppTheme.iconMd,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  'PhrasePop is a quick, fun phrase guessing game. '
                  'Letters are revealed over time, but the faster you '
                  'solve the phrase, the more points you score.',
                  style: text.bodyLarge?.copyWith(
                    color: Colors.white,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(delay: 700.ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),

        const SizedBox(height: AppTheme.spacingLg),

        // ── How to Play heading ───────────────────────────────────────────
        const NeonLabel('How to Play', accentColor: Color(0xFF35D6FF))
            .animate(delay: 780.ms)
            .fadeIn(duration: 350.ms),

        const SizedBox(height: AppTheme.spacingMd),

        // ── Steps ─────────────────────────────────────────────────────────
        ...List.generate(
          _steps.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
            child: IntroStepTile(
              index: i,
              text: _steps[i].text,
              icon: _steps[i].icon,
              gradient: _steps[i].gradient,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Internal data model for a step ────────────────────────────────────────────

class _Step {
  final String text;
  final IconData icon;
  final LinearGradient gradient;

  const _Step({
    required this.text,
    required this.icon,
    required this.gradient,
  });
}
