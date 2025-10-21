// lib/src/liquid_glass.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tahoea_liquid_glass/src/wave_painter.dart';

class TahoeaLiquidGlass extends StatefulWidget {
  const TahoeaLiquidGlass({
    super.key,
    this.blurSigma = 12.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.tintColor = const Color(0x66FFFFFF),
    this.elevation = 0.0,
    this.width,
    this.height,
    this.child,
    this.waveAmplitude = 12.0,
    this.waveFrequency = 1.4,
    this.waveSpeed = 1.0,
    this.showShine = true,
    this.shineOpacity = 0.12,
    this.padding = const EdgeInsets.all(12.0),
  });

  final double blurSigma;
  final BorderRadius borderRadius;
  final Color tintColor;
  final double elevation;
  final double? width;
  final double? height;
  final Widget? child;
  final double waveAmplitude;
  final double waveFrequency;
  final double waveSpeed;
  final bool showShine;
  final double shineOpacity;
  final EdgeInsets padding;

  @override
  State<TahoeaLiquidGlass> createState() => _TahoeaLiquidGlassState();
}

class _TahoeaLiquidGlassState extends State<TahoeaLiquidGlass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (4000 / widget.waveSpeed).round()),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant TahoeaLiquidGlass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.waveSpeed != widget.waveSpeed) {
      _controller.duration =
          Duration(milliseconds: (4000 / widget.waveSpeed).round());
      if (!_controller.isAnimating) _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurSigma,
            sigmaY: widget.blurSigma,
          ),
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.tintColor,
              borderRadius: widget.borderRadius,
              boxShadow: widget.elevation > 0
                  ? [
                      BoxShadow(
                          blurRadius: widget.elevation, color: Colors.black26)
                    ]
                  : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.child != null) widget.child!,
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: WavePainter(
                          progress: _controller.value,
                          amplitude: widget.waveAmplitude,
                          frequency: widget.waveFrequency,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.showShine)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(widget.shineOpacity),
                              Colors.white.withOpacity(0.0)
                            ],
                            stops: const [0.0, 0.6],
                          ),
                          borderRadius: widget.borderRadius,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
