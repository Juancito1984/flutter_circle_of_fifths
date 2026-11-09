# flutter_circle_of_fifths

A comprehensive, interactive, customizable Material 3 **Circle of Fifths, Chord Sheet Viewer, and Music Theory Suite** for Flutter. Supports Major and Minor modes, diatonic scale breakdown, song transposition (ChordPro), instrument chord diagrams (Guitar, Ukulele, Piano), harmonic progressions with Roman numeral analysis, Gregorian church modes, and pure Dart audio synthesis.

[![pub package](https://img.shields.io/pub/v/flutter_circle_of_fifths.svg)](https://pub.dev/packages/flutter_circle_of_fifths)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)](https://flutter.dev)

---

## 📚 Documentation by Language / Documentación por Idioma

Select your preferred language to access full widget documentation, property tables, theory explanations, and copy-paste examples:

* 🇪🇸 **[Documentación Completa en Español (`doc/es/`)](doc/es/README.md)**
  * Guías detalladas de cada widget, tablas de parámetros, personalización de interlineado y ejemplos en español.
* 🇺🇸 **[Full English Documentation Hub (`doc/en/`)](doc/en/README.md)**
  * Exhaustive guides for every widget, properties reference tables, customization options, and code samples in English.

---

## ☕ Support the Project / Apoya el Proyecto

If this package has been helpful and you'd like to support its ongoing development and maintenance, feel free to contribute:

- 💳 **PayPal**: [paypal.me/NyKservice](https://paypal.me/NyKservice)
- 🅿️ **Patreon**: [patreon.com/JuanPabloGosalvez](https://www.patreon.com/c/JuanPabloGosalvez)

Your support is greatly appreciated to keep this project 100% free, open-source, and constantly evolving!

---

## 🌟 Key Features

- 🎡 **Interactive 12-Sector Wheel**: Tap the outer ring for Major keys or the middle ring for Relative Minor keys.
- 🔄 **Dynamic 12:00 Rotation**: Smoothly centers the selected key at the top of the wheel.
- 📝 **ChordPro Song Sheet Viewer (`ChordSheetViewer`)**: Aligns interactive chord badges directly over lyrics. Tap any chord to inspect its fingerings.
- 🎚️ **Harmonic Transposition Engine (`ChordTransposer`)**: Real-time transposition by semitones (`+1` / `-1`) or directly across Circle of Fifths keys with automatic accidental adaptation (`#` vs `b`).
- 🎸 **Instrument Chord Diagrams**: Vector-drawn diagrams with barres and finger numbers for **Guitar (6 strings)**, **Ukulele (4 strings)**, and **Piano (1–3 octaves)**.
- 🎼 **Harmonic Progression Builder (`ProgressionBuilderWidget`)**: Popular templates (Pop Axis of Awesome, Jazz ii-V-I, 12-Bar Blues, Canon), Roman numeral analysis ($I, ii, iii, IV, V, vi, vii^\circ$), and secondary dominant suggestions.
- 🎷 **7 Gregorian Modes & Advanced Scales (`ScaleModesWidget`)**: Ionian, Dorian, Phrygian, Lydian, Mixolydian, Aeolian, Locrian, plus Pentatonics, Blues, Harmonic Minor, and Melodic Minor.
- 🔊 **Zero-Dependency Audio Synthesis (`SimpleAudioSynthesizer`)**: Pure Dart in-memory PCM WAV synthesis for notes and chords across all 6 Flutter platforms (Android, iOS, Web, Windows, macOS, Linux).
- 🌐 **Full Localization (i18n)**: Translate or customize all text labels (`CircleOfFifthsLabels`) across all widgets from a single place, with built-in Spanish support (`CircleOfFifthsLabels.spanish`).
- 🎨 **Material 3 Theme Adaptive**: Seamlessly adapts to light and dark themes using modern Flutter APIs.
- 📱 **Modal Sheets**: Ready-to-use draggable bottom sheets for the Circle of Fifths and chord inspection with a single function call.

---

## 🧩 Widget Catalog & Quick Links

| Widget | Summary | 🇺🇸 English Docs | 🇪🇸 Documentación ES |
| :--- | :--- | :--- | :--- |
| **`ChordSheetViewer`** | ChordPro lyrics viewer, transposition, stanzas & spacing | [📖 View Docs](doc/en/chord_sheet_viewer.md) | [📖 Ver Guía](doc/es/chord_sheet_viewer.md) |
| **`CircleOfFifthsWheelWidget`** | Interactive vector Circle of Fifths canvas wheel with 12:00 auto-rotation | [📖 View Docs](doc/en/circle_of_fifths_wheel.md) | [📖 Ver Guía](doc/es/circle_of_fifths_wheel.md) |
| **`CircleOfFifthsSheet`** | Turnkey draggable modal bottom sheet with Wheel & Summary tab views | [📖 View Docs](doc/en/circle_of_fifths_sheet.md) | [📖 Ver Guía](doc/es/circle_of_fifths_sheet.md) |
| **`ScaleDetailCard`** | Diatonic scale degrees (I–VII), interval formula, piano keybed & chord taps | [📖 View Docs](doc/en/scale_detail_card.md) | [📖 Ver Guía](doc/es/scale_detail_card.md) |
| **`ChordInspectorSheet`** | Harmonic analysis modal with Guitar, Ukulele & Piano voicings and audio | [📖 View Docs](doc/en/chord_inspector_sheet.md) | [📖 Ver Guía](doc/es/chord_inspector_sheet.md) |
| **`FretboardWidget`** | Vector string instrument fretboard (Guitar 6-string & Ukulele 4-string) | [📖 View Docs](doc/en/fretboard_widget.md) | [📖 Ver Guía](doc/es/fretboard_widget.md) |
| **`PianoKeybedWidget`** | Interactive 1–3 octave piano keyboard highlighting active scale/chord notes | [📖 View Docs](doc/en/piano_keybed_widget.md) | [📖 Ver Guía](doc/es/piano_keybed_widget.md) |
| **`ProgressionBuilderWidget`** | Roman numeral harmonic progressions, chord suggestions & playback | [📖 View Docs](doc/en/progression_builder_widget.md) | [📖 Ver Guía](doc/es/progression_builder_widget.md) |
| **`ScaleModesWidget`** | 7 Gregorian church modes & advanced scales explorer with audio scale playback | [📖 View Docs](doc/en/scale_modes_widget.md) | [📖 Ver Guía](doc/es/scale_modes_widget.md) |

---

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_of_fifths: ^1.3.0
```

Run:

```bash
flutter pub get
```

---

## 💻 Quick Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void openCircleOfFifths(BuildContext context) {
  CircleOfFifthsSheet.show(
    context,
    customTheme: const CircleOfFifthsTheme(
      centerLabel: 'NyK',
    ),
  );
}
```
