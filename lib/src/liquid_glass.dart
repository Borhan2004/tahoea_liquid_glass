// lib/src/liquid_glass.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tahoea_liquid_glass/src/wave_painter.dart';

/// iOS 18 Liquid Glass material widget.
///
/// Layer order (back → front):
///   1. BackdropFilter — gaussian blur (frosted glass base)
///   2. Tint fill — semi-transparent color layer
///   3. Dual animated waves — liquid motion
///   4. Iridescent border stroke — prismatic rim light
///   5. Specular sweep — animated diagonal shimmer
///   6. Radial gloss — top-left static highlight
class TahoeaLiquidGlass extends StatefulWidget {
  const TahoeaLiquidGlass({
    super.key,
    // Geometry
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = const EdgeInsets.all(16),
    // Material
    this.blurSigma = 28.0,
    this.tintColor = const Color(0x18FFFFFF),
    // Shadow
    this.elevation = 20.0,
    this.shadowColor = const Color(0x40000000),
    // Wave
    this.waveAmplitude = 10.0,
    this.waveFrequency = 1.6,
    this.waveSpeed = 1.0,
    this.waveColor = const Color(0x14FFFFFF),
    // Gloss
    this.showGloss = true,
    this.glossOpacity = 0.22,
    // Specular sweep
    this.showSpecularSweep = true,
    this.specularSweepDuration = const Duration(seconds: 5),
    // Border
    this.showBorder = true,
    this.borderWidth = 1.0,
    // Child
    this.child,
  });

  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final double blurSigma;
  final Color tintColor;
  final double elevation;
  final Color shadowColor;
  final double waveAmplitude;
  final double waveFrequency;
  final double waveSpeed;
  final Color waveColor;
  final bool showGloss;
  final double glossOpacity;
  final bool showSpecularSweep;
  final Duration specularSweepDuration;
  final bool showBorder;
  final double borderWidth;
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
            // Stack: passthrough so child drives intrinsic size when no
            // explicit width/height is set; overlays fill on top of content.
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                // ── 1. Content (padded) ─────────────────────────────────────
                Padding(
                  padding: widget.padding,
                  child: widget.child ?? const SizedBox.shrink(),
                ),

                // ── 2. Liquid waves ─────────────────────────────────────────
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

                // ── 3. Iridescent border ────────────────────────────────────
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

                // ── 4. Specular sweep ───────────────────────────────────────
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

                // ── 5. Top-left gloss ───────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// Internal helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Prismatic iridescent border + soft inner glow ring.
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

    // Iridescent stroke
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

    // Soft inner glow
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

/// Diagonal specular flash that sweeps left → right.
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

/// Multi-layer floating shadow.
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
