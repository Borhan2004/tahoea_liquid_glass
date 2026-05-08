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
      title: 'Tahoea Liquid Glass',
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
            fit: StackFit.expand,
            children: [
              // ── Vibrant gradient background ─────────────────────────────
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                          const Color(0xFF6B1FD9), const Color(0xFF9B3FFF), t)!,
                      Color.lerp(
                          const Color(0xFFD92B6B), const Color(0xFFFF6BAE), t)!,
                      Color.lerp(
                          const Color(0xFF1F6BD9), const Color(0xFF3FBFFF), t)!,
                    ],
                  ),
                ),
              ),

              // ── Glowing orbs ─────────────────────────────────────────────
              Positioned(
                left: size.width * (0.1 + math.sin(t * math.pi) * 0.06) - 180,
                top: size.height * (0.15 + math.cos(t * math.pi * 1.2) * 0.04) -
                    180,
                child: const _Orb(color: Color(0x99FF6BAE), size: 360),
              ),
              Positioned(
                left: size.width * (0.78 + math.cos(t * math.pi * 0.9) * 0.05) -
                    150,
                top: size.height * (0.32 + math.sin(t * math.pi * 1.1) * 0.04) -
                    150,
                child: const _Orb(color: Color(0x7740E0FF), size: 300),
              ),
              Positioned(
                left: size.width * (0.5 + math.sin(t * math.pi * 1.3) * 0.06) -
                    130,
                top: size.height * (0.65 + math.cos(t * math.pi) * 0.03) - 130,
                child: const _Orb(color: Color(0x88FFCC44), size: 260),
              ),
              Positioned(
                left: size.width * (0.2 + math.cos(t * math.pi * 1.1) * 0.04) -
                    100,
                top: size.height * (0.7 + math.sin(t * math.pi * 0.8) * 0.04) -
                    100,
                child: const _Orb(color: Color(0x6644FF88), size: 200),
              ),

              // ── Scrollable content ──────────────────────────────────────
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 28),
                      _buildHeroCard(),
                      const SizedBox(height: 16),
                      _buildWeatherRow(),
                      const SizedBox(height: 16),
                      _buildNotificationCard(),
                      const SizedBox(height: 16),
                      _buildPlayerCard(),
                      const SizedBox(height: 16),
                      _buildTagRow(),
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

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        TahoeaLiquidGlass(
          width: 48,
          height: 48,
          borderRadius: BorderRadius.circular(14),
          padding: EdgeInsets.zero,
          blurSigma: 20,
          elevation: 12,
          child: const Center(
            child:
                Icon(Icons.water_drop_rounded, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Liquid Glass',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'iOS 18 Material System',
              style: TextStyle(
                color: Color(0xCCFFFFFF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Hero card ────────────────────────────────────────────────────────────────
  Widget _buildHeroCard() {
    return TahoeaLiquidGlass(
      height: 176,
      blurSigma: 32,
      tintColor: const Color(0x20FFFFFF),
      waveAmplitude: 11,
      waveFrequency: 1.6,
      waveSpeed: 0.85,
      glossOpacity: 0.26,
      elevation: 24,
      borderRadius: BorderRadius.circular(28),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Frosted Glass UI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              TahoeaLiquidGlass(
                width: 34,
                height: 34,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.zero,
                blurSigma: 12,
                elevation: 0,
                tintColor: const Color(0x28FFFFFF),
                showSpecularSweep: false,
                child: const Center(
                  child: Icon(Icons.arrow_outward_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const Text(
            'Multi-layer translucent material with\nlive wave animations & specular sweeps.',
            style: TextStyle(
              color: Color(0xDDFFFFFF),
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const Row(
            children: [
              _Pill('Blur: 32σ'),
              SizedBox(width: 8),
              _Pill('Waves ×2'),
              SizedBox(width: 8),
              _Pill('Iridescent'),
            ],
          ),
        ],
      ),
    );
  }

  // ── Weather row ──────────────────────────────────────────────────────────────
  Widget _buildWeatherRow() {
    return Row(
      children: [
        Expanded(
          child: TahoeaLiquidGlass(
            height: 136,
            blurSigma: 28,
            tintColor: const Color(0x1EFFFFFF),
            waveAmplitude: 8,
            waveSpeed: 1.1,
            elevation: 18,
            borderRadius: BorderRadius.circular(22),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.thermostat_rounded,
                      color: Colors.white, size: 20),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '24°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Feels like 22°',
                      style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TahoeaLiquidGlass(
            height: 136,
            blurSigma: 28,
            tintColor: const Color(0x1EFFFFFF),
            waveAmplitude: 8,
            waveSpeed: 0.75,
            elevation: 18,
            borderRadius: BorderRadius.circular(22),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.air_rounded,
                      color: Colors.white, size: 20),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '12 km/h',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Wind speed',
                      style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Notification ─────────────────────────────────────────────────────────────
  Widget _buildNotificationCard() {
    return TahoeaLiquidGlass(
      blurSigma: 28,
      tintColor: const Color(0x1EFFFFFF),
      waveAmplitude: 5,
      waveSpeed: 0.6,
      elevation: 20,
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5B8AFF), Color(0xFF8B5BFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'New Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your liquid glass widget just shipped 🚀',
                  style: TextStyle(
                    color: Color(0xCCFFFFFF),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'now',
            style: TextStyle(
                color: Color(0x88FFFFFF),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ── Media player ─────────────────────────────────────────────────────────────
  Widget _buildPlayerCard() {
    return TahoeaLiquidGlass(
      blurSigma: 32,
      tintColor: const Color(0x22FFFFFF),
      waveAmplitude: 9,
      waveFrequency: 1.3,
      waveSpeed: 0.65,
      elevation: 24,
      glossOpacity: 0.24,
      borderRadius: BorderRadius.circular(26),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8844FF), Color(0xFFDD44AA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.music_note_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Aqua Dreams',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Liquid Glass OST',
                      style: TextStyle(
                          color: Color(0xCCFFFFFF), fontSize: 13, height: 1.2),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.favorite_rounded,
                  color: Color(0xFFFF6088), size: 20),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.42,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1:47',
                  style: TextStyle(
                      color: Color(0xAAFFFFFF),
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
              Text('4:12',
                  style: TextStyle(
                      color: Color(0xAAFFFFFF),
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shuffle_rounded,
                  color: Color(0xCCFFFFFF), size: 20),
              const SizedBox(width: 20),
              const Icon(Icons.skip_previous_rounded,
                  color: Colors.white, size: 28),
              const SizedBox(width: 14),
              _PlayPauseBtn(),
              const SizedBox(width: 14),
              const Icon(Icons.skip_next_rounded,
                  color: Colors.white, size: 28),
              const SizedBox(width: 20),
              const Icon(Icons.repeat_rounded,
                  color: Color(0xCCFFFFFF), size: 20),
            ],
          ),
        ],
      ),
    );
  }

  // ── Tag pills ─────────────────────────────────────────────────────────────────
  Widget _buildTagRow() {
    const tags = [
      '✦ Frosted Glass',
      '◈ Waves',
      '✧ Shimmer',
      '⬡ Depth',
      '✦ iOS 18',
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tags.map((t) => _Pill(t)).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Orb extends StatelessWidget {
  const _Orb({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return TahoeaLiquidGlass(
      blurSigma: 18,
      tintColor: const Color(0x22FFFFFF),
      waveAmplitude: 3,
      waveSpeed: 1.4,
      elevation: 6,
      borderRadius: BorderRadius.circular(50),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      showSpecularSweep: false,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _PlayPauseBtn extends StatefulWidget {
  @override
  State<_PlayPauseBtn> createState() => _PlayPauseBtnState();
}

class _PlayPauseBtnState extends State<_PlayPauseBtn> {
  bool _playing = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _playing = !_playing),
      child: TahoeaLiquidGlass(
        width: 56,
        height: 56,
        borderRadius: BorderRadius.circular(18),
        padding: EdgeInsets.zero,
        blurSigma: 20,
        tintColor: const Color(0x30FFFFFF),
        waveAmplitude: 5,
        elevation: 10,
        child: Center(
          child: Icon(
            _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
