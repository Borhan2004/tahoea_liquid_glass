// lib/src/_wave_painter.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  WavePainter({
    required this.progress,
    required this.amplitude,
    required this.frequency,
    this.color = const Color(0x33FFFFFF),
  });

  final double progress;
  final double amplitude;
  final double frequency;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final path = Path();
    const twoPi = math.pi * 2;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final normX = x / size.width;
      final y =
          size.height -
          (math.sin((normX * frequency * twoPi) + (progress * twoPi)) *
              amplitude) -
          (amplitude * 0.5);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.amplitude != amplitude;
}
