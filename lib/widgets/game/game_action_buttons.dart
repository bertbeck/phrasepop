import 'package:flutter/material.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/bouncy_button.dart';

/// Renders the "Reveal Letter" and "Hint" action buttons side-by-side.
///
/// Buttons dim when disabled (all letters revealed / hint already used).
class GameActionButtons extends StatelessWidget {
  final VoidCallback onRevealLetter;
  final VoidCallback onUseHint;
  final bool hintUsed;
  final bool allRevealed;

  const GameActionButtons({
    super.key,
    required this.onRevealLetter,
    required this.onUseHint,
    required this.hintUsed,
    required this.allRevealed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: allRevealed ? 'All Revealed' : 'Reveal Letter',
            icon: Icons.visibility_rounded,
            onPressed: allRevealed ? null : onRevealLetter,
            variant: BouncyButtonVariant.ghost,
            costLabel: '-100 pts',
          ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: _ActionButton(
            label: hintUsed ? 'Hint Used' : 'Hint',
            icon: Icons.lightbulb_rounded,
            onPressed: hintUsed ? null : onUseHint,
            variant: BouncyButtonVariant.ghost,
            costLabel: '-200 pts',
            accentColor: const Color(0xFFFFD93D),
          ),
        ),
      ],
    );
  }
}

// ─── Private helper ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final BouncyButtonVariant variant;
  final String costLabel;
  final Color? accentColor;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.variant,
    required this.costLabel,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final disabled = onPressed == null;
    final color = accentColor ?? appColors.cyan;

    return Opacity(
      opacity: disabled ? AppTheme.opacityDisabled : 1.0,
      child: Column(
        children: [
          BouncyButton(
            label: label,
            icon: icon,
            variant: variant,
            isSmall: true,
            onPressed: onPressed ?? () {},
          ),
          const SizedBox(height: 2),
          Text(
            costLabel,
            style: text.labelSmall?.copyWith(
              color: disabled ? appColors.subtleText : color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
