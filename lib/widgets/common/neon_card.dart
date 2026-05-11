import 'package:flutter/material.dart';
import 'package:primio_app/theme/theme.dart';

/// A glossy dark card with a configurable neon border glow.
///
/// Used throughout the app for all card-style surfaces —
/// score panel, hint banner, result card, etc.
class NeonCard extends StatelessWidget {
  final Widget child;

  /// The gradient or solid color painted as the border glow.
  /// Defaults to the primary purple/cyan gradient.
  final Gradient? borderGradient;

  /// Overall border opacity — lower for subtler cards.
  final double borderOpacity;

  final EdgeInsetsGeometry padding;
  final double radius;

  /// Optional extra glow shadow color beneath the card.
  final Color? glowColor;

  const NeonCard({
    super.key,
    required this.child,
    this.borderGradient,
    this.borderOpacity = 0.6,
    this.padding = const EdgeInsets.all(AppTheme.spacingMd),
    this.radius = AppTheme.radiusLg,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final effectiveBorderGradient = borderGradient ?? AppTheme.primaryGradient;
    final effectiveGlow = glowColor ?? appColors.glowPurple;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E2448),
            const Color(0xFF151930),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveGlow.withValues(alpha: 0.45),
            blurRadius: AppTheme.glowBlurMd,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _NeonBorderPainter(
          gradient: effectiveBorderGradient,
          opacity: borderOpacity,
          radius: radius,
          strokeWidth: AppTheme.borderGlow,
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Paints a gradient stroke around the card without affecting layout.
class _NeonBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double opacity;
  final double radius;
  final double strokeWidth;

  const _NeonBorderPainter({
    required this.gradient,
    required this.opacity,
    required this.radius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withValues(alpha: opacity);

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(_NeonBorderPainter old) =>
      old.opacity != opacity || old.gradient != gradient;
}
