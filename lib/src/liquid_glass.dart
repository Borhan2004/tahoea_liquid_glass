import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tahoea_liquid_glass/src/wave_painter.dart';

/// Predefined visual presets for [TahoeaLiquidGlass] to quickly apply distinct iOS styles.
enum LiquidGlassPreset {
  /// Deep classic frosted glass with high blur and subtle reflections.
  frosted,

  /// Heavy refraction/lensing effect, lower blur, high displacement translation.
  refractive,

  /// Prismatic, highly colorful rim highlights and strong gloss specular reflection.
  chromatic,

  /// A deep dark tint, neon violet waves, and bright iridescent edges.
  darkVoid,
}

class TahoeaLiquidGlass extends StatefulWidget {
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
    // iOS Liquid Glass Visual Upgrades
    this.enableTilt = true,
    this.tiltAmount = 0.06,
    this.interactiveLight = true,
    this.enableTapRipples = true,
    this.refractionAmount = 5.0,
    this.preset,
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

  // Visual & Interactive Upgrades
  final bool enableTilt;
  final double tiltAmount;
  final bool interactiveLight;
  final bool enableTapRipples;
  final double refractionAmount;
  final LiquidGlassPreset? preset;

  @override
  State<TahoeaLiquidGlass> createState() => _TahoeaLiquidGlassState();
}

class _TahoeaLiquidGlassState extends State<TahoeaLiquidGlass>
    with TickerProviderStateMixin {
  late final AnimationController _waveCtrl;
  late final AnimationController _sweepCtrl;
  late final Animation<double> _sweepAnim;

  // Parallax & Interactive light states
  final GlobalKey _cardKey = GlobalKey();
  Offset _pointerPos = Offset.zero; // Relative position [-1, 1]
  bool _isHovered = false;

  // Touch Ripple states
  late final AnimationController _rippleCtrl;
  Offset _rippleCenter = Offset.zero;

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

    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    _rippleCtrl.dispose();
    super.dispose();
  }

  // Preset configuration resolvers
  double get _resolvedBlurSigma {
    if (widget.preset == LiquidGlassPreset.frosted) return 45.0;
    if (widget.preset == LiquidGlassPreset.refractive) return 16.0;
    return widget.blurSigma;
  }

  Color get _resolvedTintColor {
    if (widget.preset == LiquidGlassPreset.darkVoid) return const Color(0x38000000);
    if (widget.preset == LiquidGlassPreset.chromatic) return const Color(0x0CFFFFFF);
    return widget.tintColor;
  }

  Color get _resolvedWaveColor {
    if (widget.preset == LiquidGlassPreset.darkVoid) return const Color(0x228E24AA); // neon violet
    return widget.waveColor;
  }

  double get _resolvedRefractionAmount {
    if (widget.preset == LiquidGlassPreset.refractive) return 10.0;
    if (widget.preset == LiquidGlassPreset.frosted) return 2.0;
    return widget.refractionAmount;
  }

  double get _resolvedGlossOpacity {
    if (widget.preset == LiquidGlassPreset.chromatic) return 0.35;
    if (widget.preset == LiquidGlassPreset.darkVoid) return 0.12;
    return widget.glossOpacity;
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enableTapRipples) return;
    setState(() {
      _rippleCenter = details.localPosition;
    });
    _rippleCtrl.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _cardKey,
      onEnter: (_) => setState(() => _isHovered = true),
      onHover: (e) {
        final renderBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final size = renderBox.size;
          setState(() {
            _isHovered = true;
            _pointerPos = Offset(
              ((e.localPosition.dx - size.width / 2) / (size.width / 2)).clamp(-1.0, 1.0),
              ((e.localPosition.dy - size.height / 2) / (size.height / 2)).clamp(-1.0, 1.0),
            );
          });
        }
      },
      onExit: (_) => setState(() {
        _isHovered = false;
        _pointerPos = Offset.zero;
      }),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        behavior: HitTestBehavior.opaque,
        child: TweenAnimationBuilder<Offset>(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: (widget.enableTilt && _isHovered) ? _pointerPos : Offset.zero,
          ),
          builder: (context, tiltOffset, child) {
            final tiltX = tiltOffset.dy * widget.tiltAmount;
            final tiltY = -tiltOffset.dx * widget.tiltAmount;

            return _GlassShadow(
              borderRadius: widget.borderRadius,
              elevation: widget.elevation,
              shadowColor: widget.shadowColor,
              tiltOffset: tiltOffset,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015) // perspective
                  ..rotateX(tiltX)
                  ..rotateY(tiltY),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _resolvedBlurSigma,
                      sigmaY: _resolvedBlurSigma,
                      tileMode: TileMode.mirror,
                    ),
                    child: Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        color: _resolvedTintColor,
                        borderRadius: widget.borderRadius,
                      ),
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          // Dynamic Lensed Parallax Child
                          Transform.translate(
                            offset: Offset(
                              -tiltOffset.dx * _resolvedRefractionAmount,
                              -tiltOffset.dy * _resolvedRefractionAmount,
                            ),
                            child: Padding(
                              padding: widget.padding,
                              child: widget.child ?? const SizedBox.shrink(),
                            ),
                          ),

                          // Dynamic Multi-Waves
                          Positioned.fill(
                            child: IgnorePointer(
                              child: AnimatedBuilder(
                                animation: _waveCtrl,
                                builder: (_, __) => CustomPaint(
                                  painter: WavePainter(
                                    progress: _waveCtrl.value,
                                    amplitude: widget.waveAmplitude,
                                    frequency: widget.waveFrequency,
                                    color: _resolvedWaveColor,
                                    secondaryColor: _resolvedWaveColor.withValues(alpha: 0.07),
                                    phaseOffset: 0.38,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Dynamic Tap Ripple Overlay
                          if (widget.enableTapRipples)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: AnimatedBuilder(
                                  animation: _rippleCtrl,
                                  builder: (_, __) => CustomPaint(
                                    painter: _RipplePainter(
                                      center: _rippleCenter,
                                      progress: _rippleCtrl.value,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          // Dynamic Iridescent Border with light shift and lensing shadow
                          if (widget.showBorder)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: _BorderPainter(
                                    borderRadius: widget.borderRadius,
                                    borderWidth: widget.borderWidth,
                                    tiltOffset: tiltOffset,
                                  ),
                                ),
                              ),
                            ),

                          // Specular Sweep Shimmer
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

                          // Interactive Light-responsive Gloss Highlight
                          if (widget.showGloss)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: widget.borderRadius,
                                    gradient: RadialGradient(
                                      center: Alignment(
                                        -0.8 + (widget.interactiveLight ? tiltOffset.dx * 0.35 : 0.0),
                                        -0.9 + (widget.interactiveLight ? tiltOffset.dy * 0.35 : 0.0),
                                      ),
                                      radius: 0.9,
                                      colors: [
                                        Colors.white.withValues(alpha: _resolvedGlossOpacity),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  const _BorderPainter({
    required this.borderRadius,
    required this.borderWidth,
    required this.tiltOffset,
  });

  final BorderRadius borderRadius;
  final double borderWidth;
  final Offset tiltOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect).deflate(borderWidth / 2);

    // Rotate SweepGradient based on tiltOffset to simulate light traveling along the rim
    final angle = math.atan2(tiltOffset.dy, tiltOffset.dx) + math.pi;
    final rotation = GradientRotation(angle);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = SweepGradient(
        center: Alignment.center,
        transform: rotation,
        colors: const [
          Color(0x66FFFFFF),
          Color(0x44B8D4FF),
          Color(0x22FFFFFF),
          Color(0x44FFE4A0),
          Color(0x22FFFFFF),
          Color(0x44A8E0FF),
          Color(0x66FFFFFF),
        ],
        stops: const [0.0, 0.18, 0.35, 0.52, 0.68, 0.84, 1.0],
      ).createShader(rect);

    canvas.drawRRect(rrect, strokePaint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..color = Colors.white.withValues(alpha: 0.12);
    canvas.drawRRect(
        borderRadius.toRRect(rect).deflate(borderWidth), glowPaint);

    // Dynamic Refractive Lensing Rim Light / Shadow Shift
    final innerRRect = borderRadius.toRRect(rect).deflate(borderWidth * 2.0);
    final lensingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 1.5
      ..shader = LinearGradient(
        begin: Alignment(tiltOffset.dx, tiltOffset.dy),
        end: Alignment(-tiltOffset.dx, -tiltOffset.dy),
        colors: [
          Colors.white.withValues(alpha: 0.20),
          Colors.white.withValues(alpha: 0.02),
          Colors.black.withValues(alpha: 0.15),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRRect(innerRRect, lensingPaint);
  }

  @override
  bool shouldRepaint(covariant _BorderPainter old) =>
      old.borderWidth != borderWidth ||
      old.borderRadius != borderRadius ||
      old.tiltOffset != tiltOffset;
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
  bool shouldRepaint(covariant _SweepPainter old) => old.progress != progress;
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({required this.center, required this.progress});
  final Offset center;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    // Expand ripple up to 75% of diagonal size
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height) * 0.75;
    final radius = maxRadius * progress;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 * (1.0 - progress)
      ..color = Colors.white.withValues(alpha: 0.25 * (1.0 - progress))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter old) =>
      old.progress != progress || old.center != center;
}

class _GlassShadow extends StatelessWidget {
  const _GlassShadow({
    required this.child,
    required this.borderRadius,
    required this.elevation,
    required this.shadowColor,
    required this.tiltOffset,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double elevation;
  final Color shadowColor;
  final Offset tiltOffset;

  @override
  Widget build(BuildContext context) {
    if (elevation <= 0) return child;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          // Ambient blur shadow shifting opposite to tilt
          BoxShadow(
            color: shadowColor,
            blurRadius: elevation * 0.8,
            spreadRadius: elevation * 0.05,
            offset: Offset(
              (elevation * 0.2) - (tiltOffset.dx * elevation * 0.15),
              (elevation * 0.2) - (tiltOffset.dy * elevation * 0.15),
            ),
          ),
          // Tight dark base shadow shifting slightly less
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.12),
            blurRadius: elevation * 0.25,
            offset: Offset(
              (elevation * 0.06) - (tiltOffset.dx * elevation * 0.08),
              (elevation * 0.06) - (tiltOffset.dy * elevation * 0.08),
            ),
          ),
          // Light top reflection shift
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.04),
            blurRadius: elevation * 0.3,
            offset: Offset(
              -tiltOffset.dx * 2,
              -1.0 - tiltOffset.dy * 2,
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}
