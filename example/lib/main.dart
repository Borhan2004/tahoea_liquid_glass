import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tahoea_liquid_glass/tahoea_liquid_glass.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const LiquidGlassShowcase(),
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
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
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
    final isDesktop = size.width > 900;

    return Scaffold(
      body: MouseRegion(
        onHover: (e) => setState(() => _mousePos = e.localPosition),
        child: AnimatedBuilder(
          animation: _bgCtrl,
          builder: (_, __) {
            final t = _bgCtrl.value;
            return Stack(
              children: [
                _buildBackground(t),
                ..._buildOrbs(t, size),
                _buildMouseGlow(),
                SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 40 : 20,
                          vertical: 40,
                        ),
                        child: Column(
                          crossAxisAlignment: isDesktop
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.stretch,
                          children: [
                            _buildHeroHeader(isDesktop),
                            const SizedBox(height: 48),
                            if (isDesktop)
                              _buildDesktopLayout()
                            else
                              _buildMobileLayout(),
                            const SizedBox(height: 60),
                            _buildFooter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroHeader(bool isDesktop) {
    return Column(
      children: [
        TahoeaLiquidGlass(
          width: 80,
          height: 80,
          borderRadius: BorderRadius.circular(24),
          blurSigma: 20,
          elevation: 30,
          child: const Center(
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Tahoea Liquid Glass',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 56 : 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'The ultimate iOS 18 glass material for Flutter.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: isDesktop ? 20 : 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: _buildMainDemoCard()),
            const SizedBox(width: 24),
            Expanded(child: _buildSideInfoCard()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildFeatureCard('Dynamic Waves', Icons.waves)),
            const SizedBox(width: 24),
            Expanded(
                child:
                    _buildFeatureCard('Prismatic Border', Icons.blur_linear)),
            const SizedBox(width: 24),
            Expanded(
                child: _buildFeatureCard('Specular Shimmer', Icons.flash_on)),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMainDemoCard(),
        const SizedBox(height: 16),
        _buildSideInfoCard(),
        const SizedBox(height: 16),
        _buildFeatureCard('Dynamic Waves', Icons.waves),
        const SizedBox(height: 16),
        _buildFeatureCard('Prismatic Border', Icons.blur_linear),
      ],
    );
  }

  Widget _buildMainDemoCard() {
    return TahoeaLiquidGlass(
      height: 320,
      blurSigma: 40,
      borderRadius: BorderRadius.circular(32),
      tintColor: Colors.white.withValues(alpha: 0.05),
      child: const Center(
        child: Text(
          'Interactive Glass Surface',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSideInfoCard() {
    return TahoeaLiquidGlass(
      height: 320,
      borderRadius: BorderRadius.circular(32),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings_input_component,
              color: Colors.white, size: 40),
          const SizedBox(height: 20),
          const Text(
            'Fully Configurable',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Adjust blur, waves, shimmer, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon) {
    return TahoeaLiquidGlass(
      height: 160,
      borderRadius: BorderRadius.circular(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
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
              const Color(0xFF0F0C29),
              Color.lerp(const Color(0xFF302B63), const Color(0xFF24243E), t)!,
              const Color(0xFF0F0C29),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrbs(double t, Size size) {
    return [
      _Orb(
        color: const Color(0xFF6B1FD9).withValues(alpha: 0.4),
        size: 600,
        left: size.width * (0.5 + math.sin(t * math.pi) * 0.2) - 300,
        top: size.height * (0.5 + math.cos(t * math.pi) * 0.2) - 300,
      ),
      _Orb(
        color: const Color(0xFFD92B6B).withValues(alpha: 0.3),
        size: 500,
        left: size.width * (0.2 + math.cos(t * math.pi * 0.8) * 0.1) - 250,
        top: size.height * (0.8 + math.sin(t * math.pi * 0.8) * 0.1) - 250,
      ),
      _Orb(
        color: const Color(0xFF1F6BD9).withValues(alpha: 0.3),
        size: 400,
        left: size.width * (0.8 + math.sin(t * math.pi * 1.2) * 0.1) - 200,
        top: size.height * (0.2 + math.cos(t * math.pi * 1.2) * 0.1) - 200,
      ),
    ];
  }

  Widget _buildMouseGlow() {
    return Positioned(
      left: _mousePos.dx - 200,
      top: _mousePos.dy - 200,
      child: IgnorePointer(
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return TahoeaLiquidGlass(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      borderRadius: BorderRadius.circular(100),
      showSpecularSweep: false,
      child: const Text(
        'Available now on pub.dev',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb(
      {required this.color,
      required this.size,
      required this.left,
      required this.top});
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
