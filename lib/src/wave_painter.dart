import 'dart:math' as math;
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  const WavePainter({
    required this.progress,
    required this.amplitude,
    required this.frequency,
    required this.color,
    required this.secondaryColor,
    required this.phaseOffset,
  });

  final double progress;
  final double amplitude;
  final double frequency;
  final Color color;
  final Color secondaryColor;
  final double phaseOffset;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Back Wave - slow, deep, lower opacity
    final paintBack = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          // ignore: deprecated_member_use
          color.withValues(alpha: color.opacity * 0.35),
          color.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);

    // 2. Mid Wave - secondary wave color
    final paintMid = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          // ignore: deprecated_member_use
          secondaryColor.withValues(alpha: secondaryColor.opacity * 0.7),
          secondaryColor.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);

    // 3. Front Wave - primary wave color, standard configuration
    final paintFront = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size);

    // Draw background layer wave: higher frequency, slightly lower amplitude, faster speed
    _drawWave(
      canvas,
      size,
      paintBack,
      progress * 1.4,
      frequency * 1.35,
      amplitude * 0.75,
      phaseOffset: phaseOffset + 1.5,
    );

    // Draw middle layer wave: lower frequency, medium speed
    _drawWave(
      canvas,
      size,
      paintMid,
      progress * 0.85,
      frequency * 0.8,
      amplitude * 0.9,
      phaseOffset: phaseOffset - 0.7,
    );

    // Draw foreground layer wave: user defined frequency & amplitude
    _drawWave(
      canvas,
      size,
      paintFront,
      progress,
      frequency,
      amplitude,
      phaseOffset: 0.0,
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    Paint paint,
    double t,
    double freq,
    double amp, {
    double phaseOffset = 0.0,
  }) {
    final path = Path();
    final yMid = size.height * 0.45;

    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      // Calculate wave angle with sinusoidal/viscous modifier
      final angle = (x / size.width) * freq * 2 * math.pi +
          (t * 2 * math.pi) +
          phaseOffset;
      
      // Multi-frequency synthesis for a more organic/fluid look
      final waveShape = math.sin(angle) * 0.85 + math.cos(angle * 0.5) * 0.15;
      final y = yMid + waveShape * amp;
      
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter old) => old.progress != progress;
}
