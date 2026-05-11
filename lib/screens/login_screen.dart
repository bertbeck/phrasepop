import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/bouncy_button.dart';
import 'package:primio_app/widgets/common/neon_background.dart';
import 'package:primio_app/widgets/common/neon_card.dart';

/// Optional auth screen (login / register).
///
/// MVP: mock — tapping Sign In just pops the route.
/// Prepared interfaces ready for REST backend integration.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLogin = true;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: NeonBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingSm),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F3A),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(color: const Color(0xFF2E3456)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXl),

                // ── Logo bubble ────────────────────────────────────────────
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: appColors.primaryPurple.withValues(alpha: AppTheme.opacityGlow),
                          blurRadius: AppTheme.glowBlurLg,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                      size: AppTheme.iconXl,
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.6, 0.6),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),
                ),

                const SizedBox(height: AppTheme.spacingLg),

                // ── Title ──────────────────────────────────────────────────
                Text(
                  _isLogin ? 'Welcome Back! 👋' : 'Join PhrasePop! 🚀',
                  style: text.headlineSmall,
                  textAlign: TextAlign.center,
                ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppTheme.spacingXs),

                Text(
                  _isLogin
                      ? 'Sign in to save your scores'
                      : 'Create an account to track your wins',
                  style: text.bodySmall?.copyWith(color: appColors.subtleText),
                  textAlign: TextAlign.center,
                ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppTheme.spacingXl),

                // ── Form card ──────────────────────────────────────────────
                NeonCard(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Column(
                    children: [
                      // Email field
                      _NeonTextField(
                        controller: _emailCtrl,
                        hint: 'Email address',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: AppTheme.spacingMd),

                      // Password field
                      _NeonTextField(
                        controller: _passCtrl,
                        hint: 'Password',
                        icon: Icons.lock_rounded,
                        obscure: _obscure,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                            size: AppTheme.iconSm,
                            color: appColors.subtleText,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingLg),

                      // Primary action
                      BouncyButton(
                        label: _isLogin ? 'Sign In' : 'Create Account',
                        icon: _isLogin ? Icons.login_rounded : Icons.person_add_rounded,
                        onPressed: () => context.pop(), // mock
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppTheme.spacingMd),

                // Toggle login / register
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(
                      _isLogin
                          ? "Don't have an account? Sign Up"
                          : 'Already have an account? Sign In',
                      style: text.bodySmall?.copyWith(
                        color: appColors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Guest option
                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Continue as Guest',
                      style: text.bodySmall?.copyWith(color: appColors.subtleText),
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Input field helper ────────────────────────────────────────────────────────

/// Neon-styled text field matching the dark game aesthetic.
class _NeonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffixIcon;

  const _NeonTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscure = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: appColors.subtleText, size: AppTheme.iconSm),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
