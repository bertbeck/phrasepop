import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:primio_app/theme/theme.dart';

/// Renders the animated dark neon background that every screen uses.
/// Includes layered radial glows and softly floating bubbles.
class NeonBackground extends StatefulWidget {
  final Widget child;

  /// If [showBubbles] is false the decorative floating bubbles are skipped
  /// (useful inside already-busy layouts to keep things clean).
  final bool showBubbles;

  const NeonBackground({
    super.key,
    required this.child,
    this.showBubbles = true,
  });

  @override
  State<NeonBackground> createState() => _NeonBackgroundState();
}

class _NeonBackgroundState extends State<NeonBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF0E1022)),
      child: Stack(
        children: [
          // Radial glow — top-left purple
          Positioned(
            top: -80,
            left: -60,
            child: _GlowCircle(
              size: 300,
              color: const Color(0xFF7B3FF2),
              opacity: 0.28,
            ),
          ),
          // Radial glow — bottom-right cyan
          Positioned(
            bottom: -100,
            right: -80,
            child: _GlowCircle(
              size: 340,
              color: const Color(0xFF35D6FF),
              opacity: 0.18,
            ),
          ),
          // Radial glow — center magenta accent
          Positioned(
            top: 200,
            right: -100,
            child: _GlowCircle(
              size: 260,
              color: const Color(0xFFD946EF),
              opacity: 0.13,
            ),
          ),

          // Floating decorative bubbles
          if (widget.showBubbles) ...[
            _FloatingBubble(
              controller: _floatController,
              left: 24,
              top: 120,
              size: 48,
              color: const Color(0xFF7B3FF2),
              delay: 0.0,
            ),
            _FloatingBubble(
              controller: _floatController,
              right: 18,
              top: 80,
              size: 32,
              color: const Color(0xFF35D6FF),
              delay: 0.3,
            ),
            _FloatingBubble(
              controller: _floatController,
              left: 60,
              bottom: 180,
              size: 22,
              color: const Color(0xFFD946EF),
              delay: 0.6,
            ),
            _FloatingBubble(
              controller: _floatController,
              right: 50,
              bottom: 220,
              size: 40,
              color: const Color(0xFFFF9F1C),
              delay: 0.15,
            ),
            _FloatingBubble(
              controller: _floatController,
              left: 120,
              top: 60,
              size: 16,
              color: const Color(0xFFFFD93D),
              delay: 0.8,
            ),
          ],

          // Content
          widget.child,
        ],
      ),
    );
  }
}

// ─── Private helper widgets ────────────────────────────────────────────────────

/// A blurred radial glow circle — used for ambient background lighting.
class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: opacity),
            blurRadius: size * 0.8,
            spreadRadius: size * 0.2,
          ),
        ],
        color: color.withValues(alpha: opacity * 0.4),
      ),
    );
  }
}

/// An animated bubble that gently floats up and down.
class _FloatingBubble extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final Color color;
  final double delay; // 0.0–1.0 offset in the animation cycle
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  const _FloatingBubble({
    required this.controller,
    required this.size,
    required this.color,
    required this.delay,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          // Offset the phase by [delay] so each bubble floats independently
          final phase = (controller.value + delay) % 1.0;
          final dy = math.sin(phase * math.pi * 2) * 12;
          return Transform.translate(
            offset: Offset(0, dy),
            child: _BubbleShape(size: size, color: color),
          );
        },
      ),
    );
  }
}

/// The visual shape of a decorative bubble — glossy sphere with highlight.
class _BubbleShape extends StatelessWidget {
  final double size;
  final Color color;

  const _BubbleShape({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 0.8,
          colors: [
            color.withValues(alpha: 0.9),
            color.withValues(alpha: 0.5),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.6),
          width: AppTheme.borderDefault,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: AppTheme.opacityGlow),
            blurRadius: AppTheme.glowBlurSm,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Align(
        alignment: const Alignment(-0.4, -0.5),
        child: Container(
          width: size * 0.25,
          height: size * 0.18,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(size),
          ),
        ),
      ),
    );
  }
}
