import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tahoea_liquid_glass/tahoea_liquid_glass.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiquidGlassShowcase(),
    );
  }
}

class LiquidGlassShowcase extends StatefulWidget {
  const LiquidGlassShowcase({super.key});

  @override
  State<LiquidGlassShowcase> createState() => _LiquidGlassShowcaseState();
}

class _LiquidGlassShowcaseState extends State<LiquidGlassShowcase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, __) {
          final t = _bgCtrl.value;
          return Stack(
            children: [
              // Vibrant animated background
              _buildBackground(t),
              ..._buildOrbs(t, size),

              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Liquid Glass',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Main Demo Card
                      TahoeaLiquidGlass(
                        height: 200,
                        blurSigma: 30,
                        tintColor: Colors.white.withValues(alpha: 0.1),
                        child: const Center(
                          child: Text(
                            'Premium iOS 18 Glass',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Responsive Row
                      Row(
                        children: [
                          Expanded(
                            child: TahoeaLiquidGlass(
                              height: 100,
                              borderRadius: BorderRadius.circular(16),
                              child: const Center(
                                child: Icon(Icons.cloud_queue, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TahoeaLiquidGlass(
                              height: 100,
                              borderRadius: BorderRadius.circular(16),
                              child: const Center(
                                child: Icon(Icons.bolt, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Interactive Element
                      TahoeaLiquidGlass(
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Center(
                          child: Text(
                            'Click Me',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground(double t) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(const Color(0xFF6B1FD9), const Color(0xFF9B3FFF), t)!,
              Color.lerp(const Color(0xFFD92B6B), const Color(0xFFFF6BAE), t)!,
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrbs(double t, Size size) {
    return [
      _Orb(
        color: const Color(0x99FF6BAE),
        size: 300,
        left: size.width * (0.1 + math.sin(t * math.pi) * 0.05) - 150,
        top: size.height * (0.2 + math.cos(t * math.pi) * 0.05) - 150,
      ),
      _Orb(
        color: const Color(0x7740E0FF),
        size: 250,
        left: size.width * (0.8 + math.cos(t * math.pi) * 0.05) - 125,
        top: size.height * (0.7 + math.sin(t * math.pi) * 0.05) - 125,
      ),
    ];
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.color, required this.size, required this.left, required this.top});
  final Color color;
  final double size;
  final double left, top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}
