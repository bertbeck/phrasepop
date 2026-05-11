import 'package:flutter/material.dart';
import 'package:primio_app/theme/theme.dart';

/// The universal interactive button for PhrasePop.
///
/// Supports three visual variants:
/// - [BouncyButtonVariant.primary] — purple/cyan gradient (hero actions)
/// - [BouncyButtonVariant.secondary] — orange/gold gradient (secondary actions)
/// - [BouncyButtonVariant.ghost] — transparent with neon border (tertiary)
class BouncyButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final BouncyButtonVariant variant;
  final bool isSmall;
  final double? width;

  const BouncyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = BouncyButtonVariant.primary,
    this.isSmall = false,
    this.width,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

enum BouncyButtonVariant { primary, secondary, ghost }

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    // Elastic bounce: shrinks on tap-down, springs back on release
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _ctrl.forward();

  void _onTapUp(TapUpDetails _) {
    _ctrl.reverse();
    widget.onPressed();
  }

  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: _ButtonBody(
          label: widget.label,
          icon: widget.icon,
          variant: widget.variant,
          isSmall: widget.isSmall,
          width: widget.width,
        ),
      ),
    );
  }
}

/// Stateless visual body — separated so it can be re-used in other contexts.
class _ButtonBody extends StatelessWidget {
  final String label;
  final IconData? icon;
  final BouncyButtonVariant variant;
  final bool isSmall;
  final double? width;

  const _ButtonBody({
    required this.label,
    required this.icon,
    required this.variant,
    required this.isSmall,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    final height = isSmall ? AppTheme.buttonHeightSm : AppTheme.buttonHeight;
    final hPad = isSmall ? AppTheme.spacingMd : AppTheme.spacingLg;
    final radius = AppTheme.radiusPill; // pill shape for premium feel

    final gradient = _resolveGradient(variant);
    final glowColor = _resolveGlow(variant, appColors);
    final isGhost = variant == BouncyButtonVariant.ghost;

    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: hPad),
      decoration: BoxDecoration(
        gradient: isGhost ? null : gradient,
        borderRadius: BorderRadius.circular(radius),
        border: isGhost
            ? Border.all(
                color: appColors.primaryPurple,
                width: AppTheme.borderSelected,
              )
            : null,
        boxShadow: isGhost
            ? null
            : [
                // Outer glow matching the button's color
                BoxShadow(
                  color: glowColor.withValues(alpha: AppTheme.opacityGlow),
                  blurRadius: AppTheme.glowBlurMd,
                  offset: const Offset(0, 6),
                ),
                // Subtle inner depth
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Colors.white,
              size: isSmall ? AppTheme.iconSm : AppTheme.iconMd,
            ),
            SizedBox(width: isSmall ? AppTheme.spacingXs : AppTheme.spacingSm),
          ],
          Text(
            label,
            style: (isSmall ? text.labelMedium : text.labelLarge)?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _resolveGradient(BouncyButtonVariant v) {
    switch (v) {
      case BouncyButtonVariant.primary:
        return AppTheme.primaryGradient;
      case BouncyButtonVariant.secondary:
        return AppTheme.secondaryGradient;
      case BouncyButtonVariant.ghost:
        return AppTheme.primaryGradient; // unused but required
    }
  }

  Color _resolveGlow(BouncyButtonVariant v, AppColors c) {
    switch (v) {
      case BouncyButtonVariant.primary:
        return c.primaryPurple;
      case BouncyButtonVariant.secondary:
        return c.orange;
      case BouncyButtonVariant.ghost:
        return c.primaryPurple;
    }
  }
}
