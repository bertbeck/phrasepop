import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/neon_card.dart';
import 'package:primio_app/widgets/common/neon_label.dart';

/// A compact scoring-rules preview card shown on the intro page.
///
/// Uses [NeonCard] with the secondary (orange/gold) gradient border
/// to visually differentiate it from the how-to-play steps.
class IntroScorePreview extends StatelessWidget {
  const IntroScorePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NeonLabel('Scoring', accentColor: Color(0xFFFFD93D))
            .animate(delay: 1200.ms)
            .fadeIn(duration: 350.ms),

        const SizedBox(height: AppTheme.spacingMd),

        NeonCard(
          borderGradient: AppTheme.secondaryGradient,
          glowColor: appColors.gold,
          borderOpacity: 0.5,
          child: Column(
            children: [
              _ScoreRow(
                icon: Icons.star_rounded,
                iconColor: appColors.gold,
                label: 'Starting score',
                value: '1000 pts',
                valueColor: appColors.gold,
              ),
              _Divider(),
              _ScoreRow(
                icon: Icons.visibility_rounded,
                iconColor: appColors.cyan,
                label: 'Each letter reveal',
                value: '−100 pts',
                valueColor: appColors.danger,
              ),
              _Divider(),
              _ScoreRow(
                icon: Icons.lightbulb_rounded,
                iconColor: appColors.magenta,
                label: 'Each hint used',
                value: '−200 pts',
                valueColor: appColors.danger,
              ),
              _Divider(),
              _ScoreRow(
                icon: Icons.close_rounded,
                iconColor: appColors.danger,
                label: 'Wrong guess',
                value: '−50 pts',
                valueColor: appColors.danger,
              ),
              _Divider(),
              _ScoreRow(
                icon: Icons.check_circle_rounded,
                iconColor: appColors.success,
                label: 'Minimum award',
                value: '100 pts',
                valueColor: appColors.success,
              ),
            ],
          ),
        )
            .animate(delay: 1280.ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
      ],
    );
  }
}

// ── Private helper widgets ─────────────────────────────────────────────────────

class _ScoreRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  const _ScoreRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXs + 2),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: AppTheme.iconSm),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
          Text(
            value,
            style: textTheme.labelMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: const Color(0xFF2E3456),
      height: AppTheme.spacingMd,
      thickness: 1,
    );
  }
}
