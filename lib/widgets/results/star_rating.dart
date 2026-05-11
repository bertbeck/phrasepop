import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primio_app/theme/theme.dart';

/// Animated star rating widget used on the results screen.
///
/// Each star scales in with an elastic bounce, staggered by 200 ms.
/// Filled stars glow gold; empty stars remain dim.
class StarRating extends StatelessWidget {
  final int stars; // 0–3

  const StarRating({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final filled = i < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
          child: _StarIcon(filled: filled, color: appColors.gold, index: i),
        );
      }),
    );
  }
}

class _StarIcon extends StatelessWidget {
  final bool filled;
  final Color color;
  final int index;

  const _StarIcon({required this.filled, required this.color, required this.index});

  @override
  Widget build(BuildContext context) {
    return Icon(
      filled ? Icons.star_rounded : Icons.star_outline_rounded,
      size: 52,
      color: filled ? color : const Color(0xFF2E3456),
      shadows: filled
          ? [
              Shadow(
                color: color.withValues(alpha: 0.8),
                blurRadius: AppTheme.glowBlurMd,
              ),
            ]
          : null,
    )
        .animate(delay: Duration(milliseconds: 300 + index * 200))
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          curve: Curves.elasticOut,
          duration: 700.ms,
        )
        .shimmer(delay: Duration(milliseconds: 900 + index * 200), duration: 600.ms);
  }
}
