import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Simple confetti burst overlay painted with CustomPainter.
///
/// Spawns [count] colored circles that fly upward from the bottom-center
/// and fade out. Requires no extra packages.
class ConfettiOverlay extends StatefulWidget {
  final bool active;
  final int count;

  const ConfettiOverlay({
    super.key,
    required this.active,
    this.count = 40,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;
  final _rand = math.Random();

  // Brand palette sourced from AppTheme gradient colors
  static const _colors = [
    Color(0xFF7B3FF2),
    Color(0xFF35D6FF),
    Color(0xFFD946EF),
    Color(0xFFFFD93D),
    Color(0xFFFF9F1C),
    Color(0xFF22C55E),
    Color(0xFFFF4D6D),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _particles = List.generate(widget.count, (_) => _Particle(_rand));
    if (widget.active) _ctrl.forward(from: 0);
  }

  @override
  void didUpdateWidget(ConfettiOverlay old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) {
      _particles = List.generate(widget.count, (_) => _Particle(_rand));
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _ConfettiPainter(
          particles: _particles,
          progress: _ctrl.value,
          colors: _colors,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final List<Color> colors;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final color = colors[i % colors.length];

      // Particles launch from bottom-center with random horizontal spread
      final x = size.width / 2 + p.xOffset * size.width * 0.5;
      final y = size.height - progress * size.height * p.speed;
      final alpha = (1.0 - progress * 1.2).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

class _Particle {
  final double xOffset; // –1 to +1
  final double speed; // 0.6–1.4
  final double size; // 3–8

  _Particle(math.Random rand)
      : xOffset = (rand.nextDouble() * 2 - 1),
        speed = 0.6 + rand.nextDouble() * 0.8,
        size = 3 + rand.nextDouble() * 5;
}
