import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primio_app/theme/theme.dart';

/// Hero branding section at the top of the intro page.
///
/// Shows the PhrasePop logo image with an elastic scale-in,
/// followed by the gradient title text and a subtitle tagline.
class IntroBrandHeader extends StatelessWidget {
  const IntroBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Logo ────────────────────────────────────────────────────────────
        Image.asset(
          'assets/images/phrasepop_logo.png',
          width: 160,
          height: 160,
          fit: BoxFit.contain,
        )
            .animate()
            .scale(
              begin: const Offset(0.0, 0.0),
              end: const Offset(1.0, 1.0),
              duration: 700.ms,
              curve: Curves.elasticOut,
            )
            .shimmer(delay: 500.ms, duration: 800.ms),

        const SizedBox(height: AppTheme.spacingMd),

        // ── Gradient title ───────────────────────────────────────────────
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            'PhrasePop!',
            style: text.headlineLarge?.copyWith(
              color: Colors.white, // overridden by ShaderMask
              fontSize: 40,
            ),
          ),
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.25, end: 0, curve: Curves.easeOut),

        const SizedBox(height: AppTheme.spacingSm),

        // ── Subtitle ─────────────────────────────────────────────────────
        Text(
          'Guess the hidden phrase before\nyou run out of clues.',
          textAlign: TextAlign.center,
          style: text.bodyLarge?.copyWith(
            color: appColors.subtleText,
            height: 1.5,
          ),
        )
            .animate(delay: 600.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
      ],
    );
  }
}
