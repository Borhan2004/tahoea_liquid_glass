# tahoea_liquid_glass

A Flutter widget that faithfully replicates the **iOS 18 Liquid Glass** material system —
deep frosted blur, dual animated liquid waves, iridescent prismatic border, specular sweep shimmer, radial gloss, and multi-layer floating shadow.

[![pub package](https://img.shields.io/pub/v/tahoea_liquid_glass.svg)](https://pub.dev/packages/tahoea_liquid_glass)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## ✨ Features

| Layer | Description |
|---|---|
| **Frosted Blur** | `BackdropFilter` with configurable Gaussian sigma |
| **Dual Waves** | Two phase-offset sine waves with gradient fill |
| **Iridescent Border** | Prismatic `SweepGradient` rim light |
| **Specular Sweep** | Animated diagonal shimmer band |
| **Radial Gloss** | Top-left static specular highlight |
| **Floating Shadow** | Multi-layer ambient + near elevation shadows |

Supports **Android · iOS · macOS · Linux · Windows · Web**.

---

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  tahoea_liquid_glass: ^0.0.2
```

Then run:

```bash
flutter pub get
```

---

## 📖 Usage

### Basic card

```dart
import 'package:tahoea_liquid_glass/tahoea_liquid_glass.dart';

// Wrap any colorful background with a Stack, then place the card on top:
Stack(
  children: [
    // Your colorful background image / gradient
    YourBackgroundWidget(),

    // The glass card
    Center(
      child: TahoeaLiquidGlass(
        width: 300,
        height: 160,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Liquid Glass', style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 8),
            Text('iOS 18 Material', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    ),
  ],
)
```

### Pill / badge

```dart
TahoeaLiquidGlass(
  borderRadius: BorderRadius.circular(50),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  showSpecularSweep: false,
  child: const Text('✦ Glass Pill', style: TextStyle(color: Colors.white)),
)
```

### Icon button

```dart
TahoeaLiquidGlass(
  width: 48,
  height: 48,
  borderRadius: BorderRadius.circular(14),
  padding: EdgeInsets.zero,
  elevation: 12,
  child: const Center(
    child: Icon(Icons.water_drop_rounded, color: Colors.white),
  ),
)
```

---

## ⚙️ Parameters

### Geometry

| Parameter | Type | Default | Description |
|---|---|---|---|
| `width` | `double?` | `null` | Explicit width (null = intrinsic) |
| `height` | `double?` | `null` | Explicit height (null = intrinsic) |
| `borderRadius` | `BorderRadius` | `circular(24)` | Corner rounding |
| `padding` | `EdgeInsets` | `all(16)` | Inner content padding |

### Glass material

| Parameter | Type | Default | Description |
|---|---|---|---|
| `blurSigma` | `double` | `28.0` | Gaussian blur strength |
| `tintColor` | `Color` | `0x18FFFFFF` | Semi-transparent tint overlay |

### Elevation / shadow

| Parameter | Type | Default | Description |
|---|---|---|---|
| `elevation` | `double` | `20.0` | Shadow depth |
| `shadowColor` | `Color` | `0x40000000` | Shadow color |

### Wave

| Parameter | Type | Default | Description |
|---|---|---|---|
| `waveAmplitude` | `double` | `10.0` | Wave height in logical pixels |
| `waveFrequency` | `double` | `1.6` | Number of wave cycles |
| `waveSpeed` | `double` | `1.0` | Playback speed multiplier |
| `waveColor` | `Color` | `0x14FFFFFF` | Primary wave color |

### Gloss & effects

| Parameter | Type | Default | Description |
|---|---|---|---|
| `showGloss` | `bool` | `true` | Top-left radial specular highlight |
| `glossOpacity` | `double` | `0.22` | Gloss intensity (0.0–1.0) |
| `showSpecularSweep` | `bool` | `true` | Animated diagonal shimmer |
| `specularSweepDuration` | `Duration` | `5s` | Time between sweeps |
| `showBorder` | `bool` | `true` | Iridescent border stroke |
| `borderWidth` | `double` | `1.0` | Border stroke width |

---

## 💡 Tips

- **The glass effect needs a colorful background to look stunning.** Place it over images, gradients, or vibrant color fields.
- For **static elements** (badges, pills), set `showSpecularSweep: false` for better performance.
- Increase `blurSigma` (e.g. `40`) for a heavier frosted look; decrease for a lighter veil.
- Combine multiple `TahoeaLiquidGlass` widgets at different opacities to create layered depth.

---

## 📄 License

MIT © [Borhan2004](https://github.com/Borhan2004)
