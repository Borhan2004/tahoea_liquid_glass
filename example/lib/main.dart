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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
      ),
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

  // Custom configuration state
  LiquidGlassPreset? _selectedPreset = LiquidGlassPreset.chromatic;
  bool _enableTilt = true;
  double _tiltAmount = 0.06;
  bool _interactiveLight = true;
  bool _enableTapRipples = true;
  double _refractionAmount = 5.0;
  double _blurSigma = 28.0;
  double _waveSpeed = 1.0;
  double _waveAmplitude = 10.0;
  bool _showBorder = true;
  bool _showGloss = true;
  bool _showSweep = true;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
    final isDesktop = size.width > 950;

    return Scaffold(
      backgroundColor: const Color(0xFF070514),
      body: MouseRegion(
        onHover: (e) => setState(() => _mousePos = e.localPosition),
        child: AnimatedBuilder(
          animation: _bgCtrl,
          builder: (context, _) {
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
                          vertical: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeroHeader(isDesktop),
                            const SizedBox(height: 32),
                            if (isDesktop)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 6, child: _buildPreviewColumn()),
                                  const SizedBox(width: 32),
                                  Expanded(flex: 5, child: _buildControlPanel()),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  _buildPreviewColumn(),
                                  const SizedBox(height: 24),
                                  _buildControlPanel(),
                                ],
                              ),
                            const SizedBox(height: 48),
                            _buildPresetShowcaseSection(isDesktop),
                            const SizedBox(height: 48),
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
          width: 72,
          height: 72,
          borderRadius: BorderRadius.circular(22),
          blurSigma: 24,
          elevation: 25,
          preset: LiquidGlassPreset.chromatic,
          child: const Center(
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tahoea Liquid Glass',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 48 : 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Dynamic physical glass materials replicating the iOS Liquid Glass system.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: isDesktop ? 18 : 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'LIVE PREVIEW (HOVER & TAP)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1),
          ),
        ),
        TahoeaLiquidGlass(
          height: 380,
          preset: _selectedPreset,
          enableTilt: _enableTilt,
          tiltAmount: _tiltAmount,
          interactiveLight: _interactiveLight,
          enableTapRipples: _enableTapRipples,
          refractionAmount: _refractionAmount,
          blurSigma: _blurSigma,
          waveSpeed: _waveSpeed,
          waveAmplitude: _waveAmplitude,
          showBorder: _showBorder,
          showGloss: _showGloss,
          showSpecularSweep: _showSweep,
          borderRadius: BorderRadius.circular(32),
          child: _buildMockMediaPlayer(),
        ),
      ],
    );
  }

  Widget _buildMockMediaPlayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF0844), Color(0xFFFFB199)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF0844).withValues(alpha: 0.4),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: const Icon(Icons.music_note_rounded, size: 38, color: Colors.white),
        ),
        const SizedBox(height: 24),
        const Text(
          'Ambient Liquid Symphony',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'iOS Liquid Material Showcase',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 28),
        // Playback progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const Expanded(flex: 6, child: SizedBox.shrink()),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1:45', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                  Text('4:12', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded, size: 28),
              color: Colors.white.withValues(alpha: 0.8),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
              ),
              child: IconButton(
                icon: const Icon(Icons.play_arrow_rounded, size: 36),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded, size: 28),
              color: Colors.white.withValues(alpha: 0.8),
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }

  Widget _buildControlPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'CONTROLS & PARAMETERS',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF13102B),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('PRESETS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 12),
              // Preset chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _presetButton('Frosted', LiquidGlassPreset.frosted),
                  _presetButton('Refractive', LiquidGlassPreset.refractive),
                  _presetButton('Chromatic', LiquidGlassPreset.chromatic),
                  _presetButton('Dark Void', LiquidGlassPreset.darkVoid),
                  _presetButton('Custom', null),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              const Text('INTERACTIVE FEATURES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 12),
              _buildSwitchRow('Enable 3D Parallax Tilt', _enableTilt, (v) => setState(() => _enableTilt = v)),
              _buildSwitchRow('Interactive Specular light', _interactiveLight, (v) => setState(() => _interactiveLight = v)),
              _buildSwitchRow('Touch / Tap Waves Ripple', _enableTapRipples, (v) => setState(() => _enableTapRipples = v)),
              _buildSwitchRow('Iridescent Rim Border', _showBorder, (v) => setState(() => _showBorder = v)),
              _buildSwitchRow('Specular Sweep Shimmer', _showSweep, (v) => setState(() => _showSweep = v)),
              _buildSwitchRow('Radial Gloss Overlay', _showGloss, (v) => setState(() => _showGloss = v)),
              const SizedBox(height: 16),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              const Text('PHYSICS & GEOMETRY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 12),
              _buildSliderRow('3D Tilt Amount', _tiltAmount, 0.0, 0.15, (v) => setState(() => _tiltAmount = v)),
              _buildSliderRow('Parallax Refraction', _refractionAmount, 0.0, 20.0, (v) => setState(() => _refractionAmount = v)),
              _buildSliderRow('Glass Blur Sigma', _blurSigma, 5.0, 80.0, (v) => setState(() => _blurSigma = v)),
              _buildSliderRow('Wave Dynamic Speed', _waveSpeed, 0.0, 3.0, (v) => setState(() => _waveSpeed = v)),
              _buildSliderRow('Wave Amplitude', _waveAmplitude, 0.0, 30.0, (v) => setState(() => _waveAmplitude = v)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _presetButton(String text, LiquidGlassPreset? preset) {
    final isSelected = _selectedPreset == preset;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPreset = preset;
          if (preset != null) {
            // Apply preset-specific helpers to local fields to align custom sliders as well
            switch (preset) {
              case LiquidGlassPreset.frosted:
                _blurSigma = 45.0;
                _refractionAmount = 2.0;
                _tiltAmount = 0.03;
                break;
              case LiquidGlassPreset.refractive:
                _blurSigma = 16.0;
                _refractionAmount = 10.0;
                _tiltAmount = 0.08;
                break;
              case LiquidGlassPreset.chromatic:
                _blurSigma = 28.0;
                _refractionAmount = 5.0;
                _tiltAmount = 0.06;
                break;
              case LiquidGlassPreset.darkVoid:
                _blurSigma = 28.0;
                _refractionAmount = 6.0;
                _tiltAmount = 0.06;
                break;
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0F0C29) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF6B1FD9),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text(value.toStringAsFixed(2), style: const TextStyle(fontSize: 11, color: Colors.white38, fontWeight: FontWeight.bold)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF6B1FD9),
              inactiveTrackColor: Colors.white10,
              thumbColor: Colors.white,
              trackHeight: 3,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: (v) {
                setState(() {
                  _selectedPreset = null; // Shift to custom mode on manual slider movement
                  onChanged(v);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetShowcaseSection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            'EXPLORE CORE PRESETS',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1),
          ),
        ),
        isDesktop
            ? Row(
                children: [
                  Expanded(child: _buildMiniPresetCard('Frosted Glass', 'Deep frosted blur & subtle depth', LiquidGlassPreset.frosted, Icons.blur_on)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildMiniPresetCard('Refractive Glass', 'Heavy lens distortion & shift', LiquidGlassPreset.refractive, Icons.waves)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildMiniPresetCard('Chromatic Iridescence', 'Dynamic rainbow edge diffractions', LiquidGlassPreset.chromatic, Icons.color_lens)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildMiniPresetCard('Dark Void', 'Sleek neon highlights in dark frame', LiquidGlassPreset.darkVoid, Icons.nightlight_round)),
                ],
              )
            : Column(
                children: [
                  _buildMiniPresetCard('Frosted Glass', 'Deep frosted blur & subtle depth', LiquidGlassPreset.frosted, Icons.blur_on),
                  const SizedBox(height: 16),
                  _buildMiniPresetCard('Refractive Glass', 'Heavy lens distortion & shift', LiquidGlassPreset.refractive, Icons.waves),
                  const SizedBox(height: 16),
                  _buildMiniPresetCard('Chromatic Iridescence', 'Dynamic rainbow edge diffractions', LiquidGlassPreset.chromatic, Icons.color_lens),
                  const SizedBox(height: 16),
                  _buildMiniPresetCard('Dark Void', 'Sleek neon highlights in dark frame', LiquidGlassPreset.darkVoid, Icons.nightlight_round),
                ],
              ),
      ],
    );
  }

  Widget _buildMiniPresetCard(String title, String desc, LiquidGlassPreset preset, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPreset = preset),
      child: TahoeaLiquidGlass(
        height: 150,
        preset: preset,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
              ),
            ],
          ),
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
              const Color(0xFF03010C),
              Color.lerp(const Color(0xFF140D36), const Color(0xFF09071E), t)!,
              const Color(0xFF03010C),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrbs(double t, Size size) {
    return [
      _Orb(
        color: const Color(0xFF6B1FD9).withValues(alpha: 0.35),
        size: 550,
        left: size.width * (0.5 + math.sin(t * math.pi) * 0.18) - 275,
        top: size.height * (0.45 + math.cos(t * math.pi) * 0.18) - 275,
      ),
      _Orb(
        color: const Color(0xFFD92B6B).withValues(alpha: 0.25),
        size: 450,
        left: size.width * (0.15 + math.cos(t * math.pi * 0.8) * 0.12) - 225,
        top: size.height * (0.75 + math.sin(t * math.pi * 0.8) * 0.12) - 225,
      ),
      _Orb(
        color: const Color(0xFF1F6BD9).withValues(alpha: 0.25),
        size: 380,
        left: size.width * (0.8 + math.sin(t * math.pi * 1.2) * 0.12) - 190,
        top: size.height * (0.2 + math.cos(t * math.pi * 1.2) * 0.12) - 190,
      ),
    ];
  }

  Widget _buildMouseGlow() {
    return Positioned(
      left: _mousePos.dx - 220,
      top: _mousePos.dy - 220,
      child: IgnorePointer(
        child: Container(
          width: 440,
          height: 440,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF6B1FD9).withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: TahoeaLiquidGlass(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        borderRadius: BorderRadius.circular(100),
        showSpecularSweep: false,
        preset: LiquidGlassPreset.frosted,
        child: const Text(
          '✦ Tahoea Liquid Glass ✦',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 1),
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.color,
    required this.size,
    required this.left,
    required this.top,
  });

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
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}
