// lib/src/wave_painter.dart
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Paints two overlapping sine waves with a phase offset to simulate
/// the liquid-glass refraction depth seen in iOS 18's material system.
class WavePainter extends CustomPainter {
  WavePainter({
    required this.progress,
    required this.amplitude,
    required this.frequency,
    this.color = const Color(0x33FFFFFF),
    this.secondaryColor = const Color(0x1AFFFFFF),
    this.phaseOffset = 0.3,
  });

  final double progress;
  final double amplitude;
  final double frequency;
  final Color color;
  final Color secondaryColor;

  /// Phase offset between the two waves (0.0 – 1.0).
  final double phaseOffset;

  @override
  void paint(Canvas canvas, Size size) {
    _drawWave(canvas, size, progress, color, amplitude);
    _drawWave(
      canvas,
      size,
      (progress + phaseOffset) % 1.0,
      secondaryColor,
      amplitude * 0.65,
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double waveProgress,
    Color waveColor,
    double waveAmplitude,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * 0.5),
        Offset(0, size.height),
        [waveColor, waveColor.withValues(alpha: 0)],
      );

    const twoPi = math.pi * 2;
    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final normX = x / size.width;
      final y = size.height -
          (math.sin((normX * frequency * twoPi) + (waveProgress * twoPi)) *
              waveAmplitude) -
          (waveAmplitude * 0.4);
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
      old.amplitude != amplitude ||
      old.phaseOffset != phaseOffset;
}
