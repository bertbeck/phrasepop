import 'package:flutter/material.dart';
import 'package:primio_app/models/phrase.dart';
import 'package:primio_app/theme/theme.dart';

/// Tappable category chip used on the home screen category row.
///
/// Selected state gets the primary purple/cyan gradient border and glow.
class CategoryChip extends StatelessWidget {
  final PhraseCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.primaryPurple.withValues(alpha: 0.25)
              : const Color(0xFF1A1F3A),
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          border: Border.all(
            color: isSelected ? appColors.primaryPurple : const Color(0xFF2E3456),
            width: isSelected ? AppTheme.borderSelected : AppTheme.borderDefault,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: appColors.primaryPurple.withValues(alpha: 0.4),
                    blurRadius: AppTheme.glowBlurSm,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category.emoji, style: text.bodyLarge),
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              category.label,
              style: text.labelMedium?.copyWith(
                color: isSelected ? Colors.white : appColors.subtleText,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
