## 0.0.5

* **Visual Assets** — Added support for screenshots and video demonstrations in the README.
* **Web/Desktop Enhancement** — Improved the example app with a premium responsive layout and interactive mouse-tracking effects.

## 0.0.4

* **Documentation Overhaul** — Added comprehensive API documentation for all public members to reach 100% documentation coverage.
* **Pub.dev Optimization** — Cleaned up package structure (removed unnecessary folders/files like `.vscode` and `public/fonts`) and updated LICENSE to standard format for maximum pub points.
* **Simplified Example** — Further refined the example app for clarity and improved its README.

## 0.0.3

* **Simplified Example** — Refactored the example app to be more concise and easier to understand while keeping the premium aesthetic.

## 0.0.2

* **Complete visual overhaul** — faithfully replicates the iOS 18 Liquid Glass material system.
* **Dual animated wave layers** — two phase-offset sine waves with gradient fill for liquid depth.
* **Iridescent prismatic border** — `SweepGradient` rim light cycling white → ice-blue → gold → sky-blue.
* **Specular sweep animation** — diagonal shimmer band that sweeps across the surface periodically.
* **Radial gloss highlight** — static top-left specular highlight matching Apple's glass style.
* **Multi-layer floating shadow** — ambient + near + top-highlight box shadows for elevation depth.
* **Fixed layout architecture** — padding now wraps content only; all visual overlays span the full card via `Positioned.fill`, preventing border/wave clipping at edges.
* **Improved default parameters** — `blurSigma` increased to 28, `tintColor` reduced to `0x18FFFFFF` for true glass transparency.
* **New parameters** — `shadowColor`, `waveColor`, `specularSweepDuration`, `showSpecularSweep`, `borderWidth`.

## 0.0.1

* Initial release — backdrop blur with tint, single animated sine wave overlay, and optional shine gradient.
