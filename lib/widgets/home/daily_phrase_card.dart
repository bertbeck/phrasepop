import 'package:flutter/material.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/neon_card.dart';

/// A tappable card on the home screen advertising the Daily Phrase challenge.
class DailyPhraseCard extends StatelessWidget {
  final VoidCallback onTap;

  const DailyPhraseCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: NeonCard(
        borderGradient: AppTheme.secondaryGradient,
        glowColor: appColors.orange,
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          children: [
            // Icon bubble — orange/gold gradient
            Container(
              width: AppTheme.iconXl + 8,
              height: AppTheme.iconXl + 8,
              decoration: BoxDecoration(
                gradient: AppTheme.secondaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: appColors.orange.withValues(alpha: AppTheme.opacityGlow),
                    blurRadius: AppTheme.glowBlurSm,
                  ),
                ],
              ),
              child: const Icon(
                Icons.today_rounded,
                color: Colors.white,
                size: AppTheme.iconLg,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Phrase ✨',
                    style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'A brand-new challenge every day!',
                    style: text.bodySmall?.copyWith(color: appColors.subtleText),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: appColors.orange,
              size: AppTheme.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}
