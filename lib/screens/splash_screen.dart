import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primio_app/features/splash/cubit/splash_cubit.dart';
import 'package:primio_app/features/splash/cubit/splash_state.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/neon_background.dart';

/// Animated logo splash shown for ~3 s on every cold start.
///
/// Animation sequence:
///   1. Dark neon background + floating bubbles (NeonBackground)
///   2. Logo image scales in with elastic bounce
///   3. Tagline fades up
///   4. Loading dots pulse
///
/// Routing:
///   While the logo animates, [SplashCubit.initialize] runs in the background.
///   Once complete it emits [SplashReady] which drives the navigation:
///   - [SplashReady.showIntro] == true  → '/intro'  (first 3 launches)
///   - [SplashReady.showIntro] == false → '/home'   (returning user)
///
///   A 3 s minimum is enforced so the animation always completes before routing.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Resolved once SplashCubit finishes — held until the timer also fires.
  bool? _showIntro;

  /// True once the 3-second minimum display timer has elapsed.
  bool _timerDone = false;

  @override
  void initState() {
    super.initState();

    // ── Kick off preference loading + launch-count increment ──────────────
    // The BlocProvider in app_router.dart creates the SplashCubit before
    // this screen builds, so context.read is safe here.
    context.read<SplashCubit>().initialize();

    // ── Minimum 3-second logo display ────────────────────────────────────
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() => _timerDone = true);
      _tryNavigate();
    });
  }

  /// Navigates when BOTH the timer has fired AND the cubit has resolved.
  void _tryNavigate() {
    if (!_timerDone || _showIntro == null) return;
    if (!mounted) return;
    context.go(_showIntro! ? '/intro' : '/home');
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    // BlocListener captures SplashReady once prefs are loaded.
    // Navigation fires when BOTH this and the 3-second timer complete.
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashReady) {
          _showIntro = state.showIntro;
          _tryNavigate();
        }
      },
      child: Scaffold(
        body: NeonBackground(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Logo ────────────────────────────────────────────────────
                Image.asset(
                  'assets/images/phrasepop_logo.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(1.0, 1.0),
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    )
                    .shimmer(delay: 600.ms, duration: 900.ms),

                const SizedBox(height: AppTheme.spacingLg),

                // ── Tagline ──────────────────────────────────────────────────
                Text(
                  'Pop the phrase! 🫧',
                  style: text.titleMedium?.copyWith(
                    color: appColors.cyan,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: appColors.cyan.withValues(alpha: 0.7),
                        blurRadius: AppTheme.glowBlurSm,
                      ),
                    ],
                  ),
                )
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

                const SizedBox(height: AppTheme.spacingXxl),

                // ── Pulsing loading dots ─────────────────────────────────────
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.primaryPurple,
                        boxShadow: [
                          BoxShadow(
                            color: appColors.primaryPurple.withValues(alpha: 0.6),
                            blurRadius: AppTheme.glowBlurSm,
                          ),
                        ],
                      ),
                    )
                        .animate(
                          delay: Duration(milliseconds: 1000 + i * 200),
                          onPlay: (c) => c.repeat(reverse: true),
                        )
                        .scaleXY(
                          begin: 0.6,
                          end: 1.3,
                          duration: 600.ms,
                          curve: Curves.easeInOut,
                        );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
