import 'package:flutter/material.dart';
import 'package:primio_app/theme/theme.dart';

/// Animated neon score meter.
///
/// Shows the current score number (counting animation) alongside a
/// gradient progress bar that glows green → amber → red as the score drops.
class ScoreDisplay extends StatelessWidget {
  final int score;
  final int maxScore;

  const ScoreDisplay({
    super.key,
    required this.score,
    this.maxScore = 1000,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final progress = (score / maxScore).clamp(0.0, 1.0);

    // Traffic-light color semantics — sourced from theme
    final Color barColor;
    final Color glowColor;
    if (progress > 0.7) {
      barColor = appColors.success;
      glowColor = appColors.success;
    } else if (progress > 0.4) {
      barColor = appColors.gold;
      glowColor = appColors.gold;
    } else {
      barColor = appColors.danger;
      glowColor = appColors.danger;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.stars_rounded, size: AppTheme.iconSm, color: appColors.gold),
                const SizedBox(width: AppTheme.spacingXs),
                Text(
                  'SCORE',
                  style: text.labelSmall?.copyWith(
                    color: appColors.subtleText,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            // Animated count-up when score changes
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: score),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (_, val, __) => Text(
                '$val',
                style: text.titleLarge?.copyWith(
                  color: barColor,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      color: glowColor.withValues(alpha: 0.7),
                      blurRadius: AppTheme.glowBlurSm,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingXs),
        // Progress bar with glow
        Stack(
          children: [
            // Track
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFF242A4A),
                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
              ),
            ),
            // Fill
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (_, val, __) => FractionallySizedBox(
                widthFactor: val,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    gradient: LinearGradient(
                      colors: [barColor, barColor.withValues(alpha: 0.6)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(alpha: 0.55),
                        blurRadius: AppTheme.glowBlurSm,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
