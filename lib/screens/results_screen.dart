import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:primio_app/models/game_result.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/bouncy_button.dart';
import 'package:primio_app/widgets/common/neon_background.dart';
import 'package:primio_app/widgets/common/neon_card.dart';
import 'package:primio_app/widgets/results/confetti_overlay.dart';
import 'package:primio_app/widgets/results/star_rating.dart';

/// Results screen — shown after each game round.
///
/// Displays score, stars, revealed phrase, quick stats
/// and action buttons for next round / home.
class ResultsScreen extends StatelessWidget {
  final GameResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    final scoreColor = result.solved ? appColors.success : appColors.danger;
    final headline = result.solved ? 'You nailed it! 🎉' : 'Brain = Popped 🧠💥';

    return Scaffold(
      body: NeonBackground(
        child: Stack(
          children: [
            // Confetti fires only on win
            ConfettiOverlay(active: result.solved),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Headline ──────────────────────────────────────────
                    Text(
                      headline,
                      style: text.headlineMedium?.copyWith(
                        shadows: [
                          Shadow(
                            color: scoreColor.withValues(alpha: 0.6),
                            blurRadius: AppTheme.glowBlurMd,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.2, end: 0),

                    const SizedBox(height: AppTheme.spacingLg),

                    // ── Stars ─────────────────────────────────────────────
                    if (result.solved) StarRating(stars: result.stars),
                    if (!result.solved) ...[
                      Icon(
                        Icons.sentiment_very_dissatisfied_rounded,
                        size: 64,
                        color: appColors.danger,
                      )
                          .animate()
                          .shake(duration: 600.ms, hz: 4)
                          .then()
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(0.9, 0.9),
                            duration: 300.ms,
                          ),
                    ],

                    const SizedBox(height: AppTheme.spacingLg),

                    // ── Score card ────────────────────────────────────────
                    _ScoreCard(result: result, scoreColor: scoreColor),

                    const Spacer(),

                    // ── Action buttons ────────────────────────────────────
                    BouncyButton(
                      label: 'One more round? 🔥',
                      icon: Icons.replay_rounded,
                      onPressed: () => context.go('/game'),
                    ).animate(delay: 900.ms).fadeIn(duration: 400.ms),

                    const SizedBox(height: AppTheme.spacingSm),

                    BouncyButton(
                      label: 'Back to Home',
                      icon: Icons.home_rounded,
                      variant: BouncyButtonVariant.ghost,
                      onPressed: () => context.go('/home'),
                    ).animate(delay: 1000.ms).fadeIn(duration: 400.ms),

                    const SizedBox(height: AppTheme.spacingSm),

                    // Share placeholder
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.share_rounded,
                        size: AppTheme.iconSm,
                        color: appColors.cyan,
                      ),
                      label: Text(
                        'Share Score',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: appColors.cyan,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ).animate(delay: 1100.ms).fadeIn(duration: 400.ms),

                    const SizedBox(height: AppTheme.spacingMd),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Score card ────────────────────────────────────────────────────────────────

class _ScoreCard extends StatelessWidget {
  final GameResult result;
  final Color scoreColor;

  const _ScoreCard({required this.result, required this.scoreColor});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return NeonCard(
      borderGradient: result.solved ? AppTheme.successGradient : AppTheme.dangerGradient,
      glowColor: scoreColor,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        children: [
          // Animated score number
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: result.solved ? result.score : 0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            builder: (_, val, __) => Text(
              '$val',
              style: text.headlineLarge?.copyWith(
                color: scoreColor,
                fontSize: 60,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    color: scoreColor.withValues(alpha: 0.7),
                    blurRadius: AppTheme.glowBlurMd,
                  ),
                ],
              ),
            ),
          )
              .animate(delay: 400.ms)
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: 700.ms,
              ),

          Text(
            'points',
            style: text.bodyMedium?.copyWith(letterSpacing: 1.5),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Phrase reveal pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm + 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1022),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Column(
              children: [
                Text(
                  result.phrase,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(result.category, style: text.labelSmall),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Revealed',
                value: '${result.lettersRevealed}',
                icon: Icons.visibility_rounded,
              ),
              _StatItem(
                label: 'Wrong',
                value: '${result.wrongGuesses}',
                icon: Icons.cancel_rounded,
              ),
              _StatItem(
                label: 'Hint',
                value: result.hintsUsed ? 'Yes' : 'No',
                icon: Icons.lightbulb_rounded,
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 500.ms).slideY(begin: 0.15, end: 0);
  }
}

// ─── Stat item ────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      children: [
        Icon(icon, size: AppTheme.iconSm, color: appColors.subtleText),
        const SizedBox(height: 2),
        Text(value, style: text.titleMedium?.copyWith(color: Colors.white)),
        Text(label, style: text.labelSmall),
      ],
    );
  }
}
