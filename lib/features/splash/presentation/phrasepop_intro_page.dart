import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primio_app/features/splash/cubit/splash_cubit.dart';
import 'package:primio_app/features/splash/presentation/widgets/intro_brand_header.dart';
import 'package:primio_app/features/splash/presentation/widgets/intro_footer.dart';
import 'package:primio_app/features/splash/presentation/widgets/intro_how_to_play.dart';
import 'package:primio_app/features/splash/presentation/widgets/intro_score_preview.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/neon_background.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

/// Maximum content width on large screens (tablet / web).
const double _kMaxContentWidth = 520.0;

/// Delay before auto-scroll begins — lets entry animations finish first.
const Duration _kAutoScrollDelay = Duration(milliseconds: 2400);

/// Total duration of the slow linear scroll from top to bottom.
/// 16 seconds gives a comfortable reading pace for all the content.
const Duration _kAutoScrollDuration = Duration(seconds: 16);

// ─── Page ─────────────────────────────────────────────────────────────────────

/// First-launch intro / onboarding page for PhrasePop.
///
/// Shown by [SplashScreen] when [SplashCubit] determines the user should
/// see the intro (fewer than 3 launches, hasn't opted out).
///
/// ### Layout
/// - **Mobile (< 600 px):** full-width, vertically scrollable column.
/// - **Wide (≥ 600 px):** content centred inside a glossy rounded card
///   capped at [_kMaxContentWidth].
///
/// ### Auto-scroll
/// After [_kAutoScrollDelay] the page slowly glides to the bottom so the
/// user discovers the "Start Playing" button without any manual effort.
///
/// The scroll is cancelled the instant the user touches the scroll view
/// (detected via [ScrollStartNotification] with non-null [dragDetails]).
/// This is the key distinction from a programmatic scroll — Flutter always
/// sets `dragDetails` on user-initiated scroll starts, and leaves it null
/// for code-driven ones.
///
/// A bouncing chevron hint is shown at the bottom until the user has
/// scrolled at least 20 px.
class PhrasepopIntroPage extends StatefulWidget {
  const PhrasepopIntroPage({super.key});

  @override
  State<PhrasepopIntroPage> createState() => _PhrasepopIntroPageState();
}

class _PhrasepopIntroPageState extends State<PhrasepopIntroPage> {
  // ── Scroll state ─────────────────────────────────────────────────────────

  /// Single controller shared by both layout branches (mobile & wide).
  final ScrollController _scrollController = ScrollController();

  /// True while the programmatic animateTo is still running.
  /// Flipped to false as soon as the user touches the view.
  bool _autoScrollActive = false;

  /// Controls visibility of the bouncing hint arrow.
  bool _showScrollHint = true;

  /// Fires the animateTo after [_kAutoScrollDelay].
  Timer? _autoScrollTimer;

  // ── Checkbox state ───────────────────────────────────────────────────────

  /// Local "Don't show again" value — only persisted on Start Playing tap.
  bool _dontShowAgain = false;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    // Listen purely to update the scroll-hint visibility.
    // We do NOT use this listener to cancel auto-scroll — that is handled by
    // the NotificationListener wrapping the scroll view (see _buildScrollView).
    _scrollController.addListener(_onScrollOffset);

    // Delay the start of auto-scroll to let entry animations settle.
    _autoScrollTimer = Timer(_kAutoScrollDelay, _startAutoScroll);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.removeListener(_onScrollOffset);
    _scrollController.dispose();
    super.dispose();
  }

  // ── Auto-scroll helpers ──────────────────────────────────────────────────

  /// Begins a slow linear animation to the bottom of the scroll content.
  void _startAutoScroll() {
    if (!mounted) return;
    if (!_scrollController.hasClients) return;

    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) return;

    setState(() => _autoScrollActive = true);

    _scrollController.animateTo(
      maxExtent,
      duration: _kAutoScrollDuration,
      curve: Curves.linear, // constant reading speed top → bottom
    );
  }

  /// Updates the hint arrow visibility based on scroll offset only.
  /// Does NOT touch auto-scroll state — that is managed by the
  /// [NotificationListener] in [_buildScrollView].
  void _onScrollOffset() {
    if (_showScrollHint && _scrollController.offset > 20) {
      if (mounted) setState(() => _showScrollHint = false);
    }
  }

  /// Called by the [NotificationListener] when a **user-initiated** drag
  /// starts.  Aborts the in-progress animateTo by jumping to the current
  /// pixel position — this immediately settles the scroll physics and hands
  /// control back to the user's finger.
  void _cancelAutoScroll() {
    if (!_autoScrollActive) return;
    if (!_scrollController.hasClients) return;
    // jumpTo aborts any running animateTo without triggering a new animation.
    _scrollController.jumpTo(_scrollController.offset);
    if (mounted) setState(() => _autoScrollActive = false);
  }

  // ── Navigation ───────────────────────────────────────────────────────────

  Future<void> _handleStartPlaying() async {
    // Persist the "Don't show again" preference if selected.
    await context
        .read<SplashCubit>()
        .dismissIntro(dontShowAgain: _dontShowAgain);
    if (mounted) context.go('/home');
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeonBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // ── Main scrollable content ────────────────────────────────
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 600;
                  return isWide
                      ? _buildWideLayout()
                      : _buildMobileLayout();
                },
              ),

              // ── Scroll-hint chevron ────────────────────────────────────
              // Shown until the user scrolls 20+ px; then fades out.
              if (_showScrollHint)
                const Positioned(
                  bottom: AppTheme.spacingMd,
                  left: 0,
                  right: 0,
                  child: _ScrollHintArrow(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Layout builders ──────────────────────────────────────────────────────

  /// Mobile: full-width scrollable column.
  Widget _buildMobileLayout() {
    return _buildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingLg,
        ),
        child: _IntroContent(
          dontShowAgain: _dontShowAgain,
          onDontShowAgainChanged: (v) => setState(() => _dontShowAgain = v),
          onStartPlaying: _handleStartPlaying,
        ),
      ),
    );
  }

  /// Wide (≥ 600 px): content centred in a capped glossy card.
  Widget _buildWideLayout() {
    return Center(
      child: _buildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingXl,
            horizontal: AppTheme.spacingLg,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
            child: _WideCard(
              child: _IntroContent(
                dontShowAgain: _dontShowAgain,
                onDontShowAgainChanged: (v) =>
                    setState(() => _dontShowAgain = v),
                onStartPlaying: _handleStartPlaying,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Wraps [child] in a [NotificationListener] that detects **user-initiated**
  /// drag starts (where `dragDetails != null`) and cancels auto-scroll.
  ///
  /// This is more reliable than `isScrollingNotifier` because Flutter always
  /// provides `dragDetails` for touch-driven scrolls and leaves it null for
  /// programmatic `animateTo` calls — so we never accidentally self-cancel.
  Widget _buildScrollView({required Widget child}) {
    return NotificationListener<ScrollStartNotification>(
      onNotification: (notification) {
        // dragDetails is non-null only when a finger initiated the scroll.
        if (notification.dragDetails != null) {
          _cancelAutoScroll();
        }
        // Return false so the notification continues bubbling.
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    );
  }
}

// ─── Content column ───────────────────────────────────────────────────────────

/// Scrollable content shared between mobile and wide layouts.
///
/// Composed entirely from extracted widget classes — no inline build methods.
class _IntroContent extends StatelessWidget {
  final bool dontShowAgain;
  final ValueChanged<bool> onDontShowAgainChanged;
  final VoidCallback onStartPlaying;

  const _IntroContent({
    required this.dontShowAgain,
    required this.onDontShowAgainChanged,
    required this.onStartPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Brand hero: logo + gradient title + subtitle
        const Center(child: IntroBrandHeader()),

        const SizedBox(height: AppTheme.spacingXl),

        // How to Play numbered steps
        const IntroHowToPlay(),

        const SizedBox(height: AppTheme.spacingXl),

        // Scoring overview card
        const IntroScorePreview(),

        const SizedBox(height: AppTheme.spacingXxl),

        // Start Playing button + Don't show again checkbox
        IntroFooter(
          dontShowAgain: dontShowAgain,
          onDontShowAgainChanged: onDontShowAgainChanged,
          onStartPlaying: onStartPlaying,
        ),

        // Breathing room at the very bottom
        const SizedBox(height: AppTheme.spacingXl),
      ],
    );
  }
}

// ─── Wide-screen card wrapper ─────────────────────────────────────────────────

/// On screens ≥ 600 px wide, wraps content in a dark glossy rounded card
/// with a purple neon border — consistent with the [NeonCard] visual system.
class _WideCard extends StatelessWidget {
  final Widget child;

  const _WideCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E2448), Color(0xFF151930)],
        ),
        border: Border.all(
          color: appColors.primaryPurple.withValues(alpha: 0.4),
          width: AppTheme.borderGlow,
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.glowPurple.withValues(alpha: 0.5),
            blurRadius: AppTheme.glowBlurLg,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: child,
    );
  }
}

// ─── Scroll hint arrow ────────────────────────────────────────────────────────

/// Gently bouncing chevron at the bottom of the screen that hints
/// there is more content below.
///
/// Ignored for pointer events so it never blocks taps on the content.
/// Fades in after a short delay so it doesn't compete with entry animations.
class _ScrollHintArrow extends StatelessWidget {
  const _ScrollHintArrow();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return IgnorePointer(
      child: Center(
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: AppTheme.iconXl,
          color: appColors.primaryPurple,
        )
            // Fade in after 2 s so it appears after entry animations
            .animate()
            .fadeIn(delay: 2000.ms, duration: 600.ms)
            // Then bounce up/down indefinitely
            .then()
            .moveY(
              begin: 0,
              end: 8,
              duration: 700.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .moveY(
              begin: 8,
              end: 0,
              duration: 700.ms,
              curve: Curves.easeInOut,
            ),
      ),
    );
  }
}
