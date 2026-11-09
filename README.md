# flutter_circle_of_fifths

A comprehensive, interactive, customizable Material 3 **Circle of Fifths, Chord Sheet Viewer, and Music Theory Suite** for Flutter. Supports Major and Minor modes, diatonic scale breakdown, song transposition (ChordPro), instrument chord diagrams (Guitar, Ukulele, Piano), harmonic progressions with Roman numeral analysis, Gregorian church modes, and pure Dart audio synthesis.

[![pub package](https://img.shields.io/pub/v/flutter_circle_of_fifths.svg)](https://pub.dev/packages/flutter_circle_of_fifths)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)](https://flutter.dev)

---

🌐 **Languages / Idiomas**: [Español](README_ES.md) | [English](README_EN.md)

---

## ☕ Support the Project / Apoya el Proyecto

If this package has been helpful and you'd like to support its ongoing development and maintenance, feel free to contribute:

- 💳 **PayPal**: [paypal.me/NyKservice](https://paypal.me/NyKservice)
- 🅿️ **Patreon**: [patreon.com/JuanPabloGosalvez](https://www.patreon.com/c/JuanPabloGosalvez)

Your support is greatly appreciated to keep this project 100% free, open-source, and constantly evolving!

---

## 🌟 Features

- 🎡 **Interactive 12-Sector Wheel**: Tap the outer ring for Major keys or the middle ring for Relative Minor keys.
- 🔄 **Dynamic 12:00 Rotation**: Smoothly centers the selected key at the top of the wheel.
- 📝 **ChordPro Song Sheet Viewer (`ChordSheetViewer`)**: Aligns interactive chord badges directly over lyrics. Tap any chord to inspect its fingerings.
- 🎚️ **Harmonic Transposition Engine (`ChordTransposer`)**: Real-time transposition by semitones (`+1` / `-1`) or directly across Circle of Fifths keys with automatic accidental adaptation (`#` vs `b`).
- 🎸 **Instrument Chord Diagrams**: Vector-drawn diagrams with barres and finger numbers for **Guitar (6 strings)**, **Ukulele (4 strings)**, and **Piano (1–3 octaves)**.
- 🎼 **Harmonic Progression Builder (`ProgressionBuilderWidget`)**: Popular templates (Pop Axis of Awesome, Jazz ii-V-I, 12-Bar Blues, Canon), Roman numeral analysis ($I, ii, iii, IV, V, vi, vii^\circ$), and secondary dominant suggestions.
- 🎷 **7 Gregorian Modes & Advanced Scales (`ScaleModesWidget`)**: Ionian, Dorian, Phrygian, Lydian, Mixolydian, Aeolian, Locrian, plus Pentatonics, Blues, Harmonic Minor, and Melodic Minor.
- 🔊 **Zero-Dependency Audio Synthesis (`SimpleAudioSynthesizer`)**: Pure Dart in-memory PCM WAV synthesis for notes and chords across all 6 Flutter platforms (Android, iOS, Web, Windows, macOS, Linux).
- 🎨 **Material 3 Theme Adaptive**: Seamlessly adapts to light and dark themes using modern Flutter APIs.
- 📱 **Modal Sheets**: Ready-to-use draggable bottom sheets for the Circle of Fifths and chord inspection with a single function call.

---

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_of_fifths: ^1.2.0
```

Run:

```bash
flutter pub get
```

---

## 💻 Usage & Examples

### 1. Circle of Fifths Modal Sheet (One Line)

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

### 2. Standalone Wheel & Diatonic Scale Card

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class MyMusicPage extends StatefulWidget {
  const MyMusicPage({super.key});

  @override
  State<MyMusicPage> createState() => _MyMusicPageState();
}

class _MyMusicPageState extends State<MyMusicPage> {
  int _selectedIndex = 0; // 0 = 'C'
  bool _isMinorMode = false;

  @override
  Widget build(BuildContext context) {
    final selectedModel = CircleOfFifthsModel.defaultKeys[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Circle of Fifths')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleOfFifthsWheelWidget(
              selectedIndex: _selectedIndex,
              isMinorMode: _isMinorMode,
              onKeySelected: (index, isMinor) {
                setState(() {
                  _selectedIndex = index;
                  _isMinorMode = isMinor;
                });
              },
            ),
            const SizedBox(height: 20),
            ScaleDetailCard(
              model: selectedModel,
              isMinorMode: _isMinorMode,
              showPianoScale: true, // Displays piano keyboard for the scale
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 3. Chord Sheet Viewer with Real-Time Transposition

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

const songText = '''
{title: Amazing Grace}
[Verse 1]
[C]Amazing [F]grace, how [C]sweet the sound
That [C]saved a [G7]wretch like [C]me!
''';

Widget buildSongViewer() {
  return ChordSheetViewer(
    songText: songText,
    originalKey: 'C',
    targetKey: 'G', // Transposes chords automatically to G Major
    showChords: true, // Set to false to hide chords and show lyrics only
    lineSpacing: 6.0, // Space between consecutive lines within a stanza
    stanzaSpacing: 18.0, // Space between stanzas (empty lines)
    showDiagramModalOnTap: true, // Opens Guitar/Ukulele/Piano modal on chord tap
  );
}
```

---

### 4. Instrument Chord Diagrams (Guitar, Ukulele, Piano)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

// Open modal inspector for any chord
void inspectChord(BuildContext context, String chord) {
  ChordInspectorSheet.show(context, chordSymbol: chord);
}

// Or embed diagrams directly:
Widget buildDiagrams() {
  final chord = ChordTransposer.parseChord('G7');
  return Column(
    children: [
      FretboardWidget(voicing: chord.guitarVoicing, chordTitle: 'G7 (Guitar)'),
      FretboardWidget(voicing: chord.ukuleleVoicing, chordTitle: 'G7 (Ukulele)'),
      PianoKeybedWidget(highlightedNotes: chord.notes, rootNote: chord.root),
    ],
  );
}
```

---

### 5. Harmonic Progression Builder & Roman Numerals

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

Widget buildProgression() {
  return const ProgressionBuilderWidget(
    activeKey: 'C',
  );
}
```

---

### 6. Gregorian Modes & Advanced Scales

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

Widget buildScaleExplorer() {
  return const ScaleModesWidget(
    rootNote: 'D', // Explores Dorian, Phrygian, Lydian, Blues, etc.
  );
}
```

---

### 7. Localization & Custom Language (i18n)

Customize or translate all UI text across the entire suite from a single place using `CircleOfFifthsLabels`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

// Option A: Use the built-in Spanish translations
final spanishLabels = CircleOfFifthsLabels.spanish;

// Option B: Customize specific labels using copyWith
final customLabels = CircleOfFifthsLabels.spanish.copyWith(
  tapDegreeForChordHint: 'Tap to inspect chord',
);

// Option C: Define all translations from your app's localization (l10n)
final myLabels = CircleOfFifthsLabels(
  title: context.l10n.circleOfFifths,
  interactiveWheelLabel: context.l10n.interactiveWheel,
  summaryViewLabel: context.l10n.summaryView,
  majorLabel: context.l10n.major,
  minorLabel: context.l10n.minor,
  tapDegreeForChordHint: context.l10n.tapDegreeHint,
  transposeLabel: context.l10n.transpose,
  resetLabel: context.l10n.reset,
  keyLabel: context.l10n.key,
  uniqueChordsLabel: context.l10n.songChords,
  guitarLabel: context.l10n.guitar,
  ukuleleLabel: context.l10n.ukulele,
  pianoLabel: context.l10n.piano,
  progressionTitle: context.l10n.progressionTitle,
  modesCategoryLabel: context.l10n.modes,
  advancedCategoryLabel: context.l10n.advanced,
);

// Pass it to any widget or modal sheet:
void showLocalized(BuildContext context) {
  CircleOfFifthsSheet.show(context, labels: myLabels);
}
```

---

## 🎨 Custom Theme Configuration

```dart
CircleOfFifthsTheme(
  centerLabel: 'NyK',
  tonicColor: Colors.amber,
  subdominantDominantColor: Colors.deepOrange,
  minorChordsColor: Colors.teal,
  diminishedColor: Colors.indigo,
)
```

---

## 📂 Project Structure

```
lib/
├── flutter_circle_of_fifths.dart          # Main package exports
└── src/
    ├── audio/
    │   └── simple_audio_synthesizer.dart  # Pure Dart in-memory PCM WAV synthesis
    ├── models/
    │   ├── chord_model.dart               # Chords, intervals, voicings & transposer
    │   ├── chord_sheet_parser.dart        # ChordPro & bracket notation parser
    │   ├── circle_of_fifths_model.dart    # Circle of Fifths keys & diatonic scales
    │   ├── harmonic_progression_model.dart# Roman numeral analysis & progressions
    │   └── scale_mode_model.dart          # 7 Gregorian modes & advanced scales
    ├── theme/
    │   └── circle_of_fifths_theme.dart    # Color palette & brand label
    └── widgets/
        ├── chord_inspector_sheet.dart     # Interactive chord diagram modal sheet
        ├── chord_sheet_viewer.dart        # ChordPro song viewer & transposer bar
        ├── circle_of_fifths_sheet.dart    # Draggable Modal Sheet with Wheel & Grid
        ├── circle_of_fifths_wheel.dart    # Canvas Wheel widget with touch rotation
        ├── fretboard_widget.dart          # Vector fretboard for Guitar & Ukulele
        ├── piano_keybed_widget.dart       # Vector piano keyboard (1-3 octaves)
        ├── progression_builder_widget.dart# Harmonic progression builder with Roman numerals
        ├── scale_detail_card.dart         # Diatonic scale card with tap-to-chord
        └── scale_modes_widget.dart        # Gregorian modes & scale explorer
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
