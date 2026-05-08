// lib/src/liquid_glass.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tahoea_liquid_glass/src/wave_painter.dart';

/// A high-fidelity Flutter widget that faithfully replicates the iOS 18 "Liquid Glass" material.
///
/// This widget combines multiple layers to achieve its premium look:
/// 1. **BackdropFilter** — A deep Gaussian blur for the frosted base.
/// 2. **Tint** — A semi-transparent color overlay.
/// 3. **Animated Waves** — Dual sine waves for a liquid depth illusion.
/// 4. **Iridescent Border** — A prismatic rim light that cycles colors.
/// 5. **Specular Sweep** — An animated diagonal shimmer flash.
/// 6. **Radial Gloss** — A static top-left highlight.
///
/// The widget can be used as a container for other UI elements, providing a
/// translucent, glass-like background.
class TahoeaLiquidGlass extends StatefulWidget {
  /// Creates an iOS 18 style Liquid Glass widget.
  const TahoeaLiquidGlass({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = const EdgeInsets.all(16),
    this.blurSigma = 28.0,
    this.tintColor = const Color(0x18FFFFFF),
    this.elevation = 20.0,
    this.shadowColor = const Color(0x40000000),
    this.waveAmplitude = 10.0,
    this.waveFrequency = 1.6,
    this.waveSpeed = 1.0,
    this.waveColor = const Color(0x14FFFFFF),
    this.showGloss = true,
    this.glossOpacity = 0.22,
    this.showSpecularSweep = true,
    this.specularSweepDuration = const Duration(seconds: 5),
    this.showBorder = true,
    this.borderWidth = 1.0,
    this.child,
  });

  /// The explicit width of the widget. If null, it will size itself to its child.
  final double? width;

  /// The explicit height of the widget. If null, it will size itself to its child.
  final double? height;

  /// The corner radius of the glass card. Defaults to 24.
  final BorderRadius borderRadius;

  /// The padding for the [child] widget inside the glass container.
  final EdgeInsets padding;

  /// The strength of the Gaussian blur (frosted effect). Defaults to 28.0.
  final double blurSigma;

  /// The semi-transparent color overlay applied to the glass.
  final Color tintColor;

  /// The shadow depth/elevation. Set to 0.0 to disable shadows.
  final double elevation;

  /// The color of the multi-layer shadow.
  final Color shadowColor;

  /// The height of the animated liquid waves in logical pixels.
  final double waveAmplitude;

  /// The frequency (number of cycles) of the sine waves.
  final double waveFrequency;

  /// The speed multiplier for the wave animations. 1.0 is standard.
  final double waveSpeed;

  /// The base color of the animated liquid waves.
  final Color waveColor;

  /// Whether to show the static top-left radial gloss highlight.
  final bool showGloss;

  /// The opacity of the radial gloss highlight (0.0 to 1.0).
  final double glossOpacity;

  /// Whether to show the periodic diagonal specular shimmer animation.
  final bool showSpecularSweep;

  /// The duration of a full specular sweep cycle, including the pause.
  final Duration specularSweepDuration;

  /// Whether to show the iridescent prismatic border stroke.
  final bool showBorder;

  /// The thickness of the iridescent border.
  final double borderWidth;

  /// The widget to display inside the glass container.
  final Widget? child;

  @override
  State<TahoeaLiquidGlass> createState() => _TahoeaLiquidGlassState();
}

class _TahoeaLiquidGlassState extends State<TahoeaLiquidGlass>
    with TickerProviderStateMixin {
  late final AnimationController _waveCtrl;
  late final AnimationController _sweepCtrl;
  late final Animation<double> _sweepAnim;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (4000 / widget.waveSpeed).round()),
    )..repeat();

    _sweepCtrl = AnimationController(
      vsync: this,
      duration: widget.specularSweepDuration,
    )..repeat();

    _sweepAnim = CurvedAnimation(
      parent: _sweepCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant TahoeaLiquidGlass old) {
    super.didUpdateWidget(old);
    if (old.waveSpeed != widget.waveSpeed) {
      _waveCtrl.duration =
          Duration(milliseconds: (4000 / widget.waveSpeed).round());
      if (!_waveCtrl.isAnimating) _waveCtrl.repeat();
    }
    if (old.specularSweepDuration != widget.specularSweepDuration) {
      _sweepCtrl.duration = widget.specularSweepDuration;
      if (!_sweepCtrl.isAnimating) _sweepCtrl.repeat();
    }
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _sweepCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GlassShadow(
      borderRadius: widget.borderRadius,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurSigma,
            sigmaY: widget.blurSigma,
            tileMode: TileMode.mirror,
          ),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.tintColor,
              borderRadius: widget.borderRadius,
            ),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Padding(
                  padding: widget.padding,
                  child: widget.child ?? const SizedBox.shrink(),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _waveCtrl,
                      builder: (_, __) => CustomPaint(
                        painter: WavePainter(
                          progress: _waveCtrl.value,
                          amplitude: widget.waveAmplitude,
                          frequency: widget.waveFrequency,
                          color: widget.waveColor,
                          secondaryColor:
                              widget.waveColor.withValues(alpha: 0.07),
                          phaseOffset: 0.38,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.showBorder)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _BorderPainter(
                          borderRadius: widget.borderRadius,
                          borderWidth: widget.borderWidth,
                        ),
                      ),
                    ),
                  ),
                if (widget.showSpecularSweep)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _sweepAnim,
                        builder: (_, __) => CustomPaint(
                          painter: _SweepPainter(
                            progress: _sweepAnim.value,
                            borderRadius: widget.borderRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.showGloss)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: widget.borderRadius,
                          gradient: RadialGradient(
                            center: const Alignment(-0.8, -0.9),
                            radius: 0.9,
                            colors: [
                              Colors.white
                                  .withValues(alpha: widget.glossOpacity),
                              Colors.white.withValues(alpha: 0),
                            ],
                            stops: const [0.0, 1.0],
                          ),
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

class _BorderPainter extends CustomPainter {
  const _BorderPainter({
    required this.borderRadius,
    required this.borderWidth,
  });

  final BorderRadius borderRadius;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect).deflate(borderWidth / 2);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = const SweepGradient(
        colors: [
          Color(0x66FFFFFF),
          Color(0x44B8D4FF),
          Color(0x22FFFFFF),
          Color(0x44FFE4A0),
          Color(0x22FFFFFF),
          Color(0x44A8E0FF),
          Color(0x66FFFFFF),
        ],
        stops: [0.0, 0.18, 0.35, 0.52, 0.68, 0.84, 1.0],
      ).createShader(rect);

    canvas.drawRRect(rrect, strokePaint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..color = const Color(0x1EFFFFFF);
    canvas.drawRRect(borderRadius.toRRect(rect).deflate(borderWidth), glowPaint);
  }

  @override
  bool shouldRepaint(covariant _BorderPainter old) =>
      old.borderWidth != borderWidth || old.borderRadius != borderRadius;
}

class _SweepPainter extends CustomPainter {
  const _SweepPainter({required this.progress, required this.borderRadius});

  final double progress;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final bandW = size.width * 0.32;
    final center = (size.width + bandW) * progress - bandW * 0.5;
    final left = center - bandW / 2;

    final shader = const LinearGradient(
      colors: [
        Color(0x00FFFFFF),
        Color(0x10FFFFFF),
        Color(0x20FFFFFF),
        Color(0x10FFFFFF),
        Color(0x00FFFFFF),
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    ).createShader(Rect.fromLTWH(left, 0, bandW, size.height));

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = shader;

    canvas.save();
    canvas.clipRRect(borderRadius.toRRect(Offset.zero & size));
    canvas.skew(-0.22, 0);
    canvas.drawRect(Rect.fromLTWH(left, 0, bandW, size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SweepPainter old) =>
      old.progress != progress;
}

class _GlassShadow extends StatelessWidget {
  const _GlassShadow({
    required this.child,
    required this.borderRadius,
    required this.elevation,
    required this.shadowColor,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double elevation;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    if (elevation <= 0) return child;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: elevation * 0.8,
            spreadRadius: elevation * 0.05,
            offset: Offset(0, elevation * 0.2),
          ),
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.12),
            blurRadius: elevation * 0.25,
            offset: Offset(0, elevation * 0.06),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.04),
            blurRadius: elevation * 0.3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: child,
    );
  }
}
