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
    final paint1 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size);

    final paint2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [secondaryColor, secondaryColor.withValues(alpha: 0)],
      ).createShader(Offset.zero & size);

    _drawWave(canvas, size, paint2, progress, frequency, amplitude,
        phaseOffset: phaseOffset);

    _drawWave(canvas, size, paint1, progress, frequency, amplitude);
  }

  void _drawWave(
      Canvas canvas, Size size, Paint paint, double t, double freq, double amp,
      {double phaseOffset = 0.0}) {
    final path = Path();
    final yMid = size.height * 0.45;

    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final angle = (x / size.width) * freq * 2 * math.pi +
          (t * 2 * math.pi) +
          phaseOffset;
      final y = yMid + math.sin(angle) * amp;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter old) => old.progress != progress;
}
