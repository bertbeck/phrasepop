import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/neon_card.dart';

/// A single numbered step in the "How to Play" section.
///
/// Each tile stagger-animates in from the left based on [index],
/// creating a cascading reveal effect.
class IntroStepTile extends StatelessWidget {
  final int index;
  final String text;
  final IconData icon;
  final Gradient gradient;

  const IntroStepTile({
    super.key,
    required this.index,
    required this.text,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Stagger delay: each step appears 120 ms after the previous
    final delay = Duration(milliseconds: 800 + index * 120);

    return NeonCard(
      borderGradient: gradient,
      glowColor: _glowColorFromGradient(gradient),
      borderOpacity: 0.5,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm + AppTheme.spacingXs,
      ),
      child: Row(
        children: [
          // ── Step number badge ──────────────────────────────────────────
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _glowColorFromGradient(gradient)
                      .withValues(alpha: AppTheme.opacityGlow),
                  blurRadius: AppTheme.glowBlurSm,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacingMd),

          // ── Icon ────────────────────────────────────────────────────
          ShaderMask(
            shaderCallback: (b) => gradient.createShader(b),
            child: Icon(icon, color: Colors.white, size: AppTheme.iconMd),
          ),

          const SizedBox(width: AppTheme.spacingSm),

          // ── Step description ────────────────────────────────────────
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 400.ms)
        .slideX(begin: -0.15, end: 0, curve: Curves.easeOut);
  }

  /// Extracts the first color from the gradient for glow matching.
  Color _glowColorFromGradient(Gradient g) {
    if (g is LinearGradient && g.colors.isNotEmpty) return g.colors.first;
    return const Color(0xFF7B3FF2);
  }
}
