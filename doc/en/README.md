# 📚 English Documentation - flutter_circle_of_fifths

A comprehensive, interactive, customizable Material 3 **Circle of Fifths, Chord Sheet Viewer, and Music Theory Suite** for Flutter. Supports Major and Minor modes, diatonic scale breakdown, song transposition (ChordPro), instrument chord diagrams (Guitar, Ukulele, Piano), harmonic progressions with Roman numeral analysis, Gregorian church modes, and pure Dart audio synthesis.

[![pub package](https://img.shields.io/pub/v/flutter_circle_of_fifths.svg)](https://pub.dev/packages/flutter_circle_of_fifths)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)](https://flutter.dev)

*🌍 [Ver Documentación en Español](../es/README.md) | [🏠 Main Cover](../../README.md)*

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

## 🧩 Complete Widget Catalog & Individual Guides

Explore the dedicated technical documentation, property tables, and copy-paste examples for every widget in the suite:

| Widget | Source File | Full Documentation | Summary of Functionality |
| :--- | :--- | :--- | :--- |
| **`ChordSheetViewer`** | [`chord_sheet_viewer.dart`](../../lib/src/widgets/chord_sheet_viewer.dart) | [📖 ChordSheetViewer Guide](chord_sheet_viewer.md) | Interactive ChordPro / bracket-notation lyrics viewer with transposition, `showChords`, custom line & stanza spacing. |
| **`CircleOfFifthsWheelWidget`** | [`circle_of_fifths_wheel.dart`](../../lib/src/widgets/circle_of_fifths_wheel.dart) | [📖 CircleOfFifthsWheelWidget Guide](circle_of_fifths_wheel.md) | Interactive vector canvas wheel with 12:00 auto-rotation, key signatures, and diatonic scale degrees. |
| **`CircleOfFifthsSheet`** | [`circle_of_fifths_sheet.dart`](../../lib/src/widgets/circle_of_fifths_sheet.dart) | [📖 CircleOfFifthsSheet Guide](circle_of_fifths_sheet.md) | Turnkey draggable Modal Bottom Sheet with interactive wheel and summary grid tabs via `.show(...)`. |
| **`ScaleDetailCard`** | [`scale_detail_card.dart`](../../lib/src/widgets/scale_detail_card.dart) | [📖 ScaleDetailCard Guide](scale_detail_card.md) | Diatonic degrees (I–VII), interval formulas, primary/secondary chords, and interactive piano keybed. |
| **`ChordInspectorSheet`** | [`chord_inspector_sheet.dart`](../../lib/src/widgets/chord_inspector_sheet.dart) | [📖 ChordInspectorSheet Guide](chord_inspector_sheet.md) | Modal chord analysis with Guitar, Ukulele, and Piano voicings and audio synthesis. |
| **`FretboardWidget`** | [`fretboard_widget.dart`](../../lib/src/widgets/fretboard_widget.dart) | [📖 FretboardWidget Guide](fretboard_widget.md) | Vector string instrument fretboard (Guitar 6-string & Ukulele 4-string) with barres and finger numbers. |
| **`PianoKeybedWidget`** | [`piano_keybed_widget.dart`](../../lib/src/widgets/piano_keybed_widget.dart) | [📖 PianoKeybedWidget Guide](piano_keybed_widget.md) | Interactive 1–3 octave piano keyboard highlighting active scale/chord notes and touch feedback. |
| **`ProgressionBuilderWidget`** | [`progression_builder_widget.dart`](../../lib/src/widgets/progression_builder_widget.dart) | [📖 ProgressionBuilderWidget Guide](progression_builder_widget.md) | Interactive Roman numeral harmonic progressions, chord suggestions, and rhythmic playback. |
| **`ScaleModesWidget`** | [`scale_modes_widget.dart`](../../lib/src/widgets/scale_modes_widget.dart) | [📖 ScaleModesWidget Guide](scale_modes_widget.md) | 7 Gregorian church modes & advanced scales explorer with ascending scale audio synthesis. |

---

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_of_fifths: ^1.3.1
```

Run:

```bash
flutter pub get
```

---

## 💻 Quick Code Examples

### 1. Show Circle of Fifths Modal Sheet (One Line)

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

---

### 2. Chord Sheet Viewer with Real-Time Transposition

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

const songSample = '''
{title: Amazing Grace}
[Verse 1]
[C]Amazing [F]grace, how [C]sweet the sound
That [C]saved a [G7]wretch like [C]me!
''';

Widget songViewer() {
  return ChordSheetViewer(
    songText: songSample,
    originalKey: 'C',
    targetKey: 'G', // Transposes automatically to G Major
    showChords: true,
    lineSpacing: 6.0,
    stanzaSpacing: 18.0,
    showDiagramModalOnTap: true,
  );
}
```
