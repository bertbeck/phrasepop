import 'package:flutter/material.dart';
import 'package:primio_app/theme/theme.dart';

/// A small section heading with a colored left-accent bar.
/// Used on Home and Game screens for "Choose a Category", "Hint", etc.
class NeonLabel extends StatelessWidget {
  final String text;
  final Color? accentColor;

  const NeonLabel(this.text, {super.key, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final color = accentColor ?? appColors.cyan;

    return Row(
      children: [
        // Neon accent bar
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.6),
                blurRadius: AppTheme.glowBlurSm,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Text(
          text,
          style: style.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
