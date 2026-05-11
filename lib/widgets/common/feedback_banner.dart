import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primio_app/theme/theme.dart';

/// A short animated banner that slides in to show game feedback messages.
///
/// Variants drive the color and icon automatically.
class FeedbackBanner extends StatelessWidget {
  final String message;
  final FeedbackType type;

  const FeedbackBanner({
    super.key,
    required this.message,
    this.type = FeedbackType.info,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    final (color, icon) = _resolve(type, appColors);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: AppTheme.borderDefault,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: AppTheme.glowBlurSm,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: AppTheme.iconSm),
          const SizedBox(width: AppTheme.spacingXs),
          Flexible(
            child: Text(
              message,
              style: text.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack, duration: 350.ms);
  }

  (Color, IconData) _resolve(FeedbackType type, AppColors c) {
    switch (type) {
      case FeedbackType.success:
        return (c.success, Icons.check_circle_rounded);
      case FeedbackType.error:
        return (c.danger, Icons.cancel_rounded);
      case FeedbackType.hint:
        return (c.gold, Icons.lightbulb_rounded);
      case FeedbackType.info:
        return (c.cyan, Icons.info_rounded);
    }
  }
}

enum FeedbackType { success, error, hint, info }
