# 🔍 ChordInspectorSheet

The **`ChordInspectorSheet`** widget is an interactive modal sheet designed for deep harmonic analysis of any musical chord. It displays interval formulas, constituent notes, and tabs with real chord diagrams for **Guitar**, **Ukulele**, and **Piano** with audio synthesis.

---

## 🎯 Key Features

1. **One-Line Static Opener**:
   * Inspect any chord symbol on the fly using `ChordInspectorSheet.show(context, chordSymbol: "G7")`.
2. **Harmonic Formula Breakdown**:
   * Displays root, chord quality (Major, Minor, 7th, Maj7, Sus4, Dim, etc.), inverted bass note (slash chords like `D/F#`), interval formula (1 - 3 - 5 - b7), and spelled note list.
3. **Instrument Diagram Tabs**:
   * **Guitar**: 6-string fretboard with barres, finger numbers, and muted/open strings.
   * **Ukulele**: 4-string fretboard in standard G-C-E-A tuning with recommended fingerings.
   * **Piano**: 2-octave keybed highlighting pressed keys with note labels.
4. **Modular Sound Synthesis (`SimpleAudioSynthesizer`)**:
   * Computes the chord frequencies and uncompressed PCM WAV audio in memory via `SimpleAudioSynthesizer`, allowing developers to play it through any audio engine without bloat.
5. **Localization (i18n)**:
   * Compatible with [`CircleOfFifthsLabels`](../../lib/src/theme/circle_of_fifths_labels.dart) to customize instrument tabs and headers.

---

## ⚙️ Properties Table

### Constructor & `ChordInspectorSheet.show(...)` Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`chordInfo`** *(required in constructor)* | `ChordInfo` | — | Parsed chord model containing intervals, notes, and voicings. |
| **`chordSymbol`** *(required in `.show`)* | `String` | — | Chord name string to inspect (e.g., `'C'`, `'Am7'`, `'F#m'`, `'C/G'`). |
| **`initialInstrument`** | `InstrumentType` | `InstrumentType.guitar` | Initial instrument tab displayed (`guitar`, `ukulele`, `piano`). |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Localization instance for headers and instrument tab names. |

---

## 💻 Code Examples

### 1. Open Inspector from a Button

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class ChordInspectButton extends StatelessWidget {
  const ChordInspectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ChordInspectorSheet.show(
          context,
          chordSymbol: 'Bm7',
          initialInstrument: InstrumentType.guitar,
        );
      },
      child: const Text('Inspect Bm7'),
    );
  }
}
```
