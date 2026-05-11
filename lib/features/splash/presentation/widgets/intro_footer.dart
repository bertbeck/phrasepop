import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/bouncy_button.dart';

/// Footer section of the intro page.
///
/// Contains:
/// - The primary "Start Playing" [BouncyButton]
/// - A "Don't show again" checkbox row
///
/// Callbacks are forwarded to the parent intro page to keep this
/// widget purely presentational.
class IntroFooter extends StatelessWidget {
  final bool dontShowAgain;
  final ValueChanged<bool> onDontShowAgainChanged;
  final VoidCallback onStartPlaying;

  const IntroFooter({
    super.key,
    required this.dontShowAgain,
    required this.onDontShowAgainChanged,
    required this.onStartPlaying,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Start Playing button ──────────────────────────────────────────
        BouncyButton(
          label: 'Start Playing! 🎉',
          icon: Icons.play_arrow_rounded,
          onPressed: onStartPlaying,
        )
            .animate(delay: 1600.ms)
            .fadeIn(duration: 400.ms)
            .scale(
              begin: const Offset(0.85, 0.85),
              end: const Offset(1.0, 1.0),
              curve: Curves.elasticOut,
              duration: 600.ms,
            ),

        const SizedBox(height: AppTheme.spacingMd),

        // ── Don't show again checkbox ─────────────────────────────────────
        GestureDetector(
          onTap: () => onDontShowAgainChanged(!dontShowAgain),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom neon checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  gradient: dontShowAgain ? AppTheme.primaryGradient : null,
                  color: dontShowAgain ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm - 4),
                  border: Border.all(
                    color: dontShowAgain
                        ? appColors.primaryPurple
                        : appColors.subtleText,
                    width: AppTheme.borderSelected,
                  ),
                  boxShadow: dontShowAgain
                      ? [
                          BoxShadow(
                            color: appColors.primaryPurple.withValues(
                              alpha: AppTheme.opacityGlow,
                            ),
                            blurRadius: AppTheme.glowBlurSm,
                          ),
                        ]
                      : null,
                ),
                child: dontShowAgain
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),

              const SizedBox(width: AppTheme.spacingSm),

              Text(
                "Don't show again",
                style: textTheme.bodyMedium?.copyWith(
                  color: dontShowAgain ? Colors.white : appColors.subtleText,
                ),
              ),
            ],
          ),
        )
            .animate(delay: 1750.ms)
            .fadeIn(duration: 350.ms),
      ],
    );
  }
}
