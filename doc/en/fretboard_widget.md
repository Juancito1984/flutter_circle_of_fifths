# 🎸 FretboardWidget

The **`FretboardWidget`** is a vector diagram component that paints accurate fretboard diagrams for fretted string instruments: **Guitar** (6 strings) and **Ukulele** (4 strings).

---

## 🎯 Key Features

1. **Crisp Vector Drawing via `CustomPainter`**:
   * Draws nuts, frets, metal strings, barre indicators, and finger placement markers.
2. **Comprehensive String Notation**:
   * **Finger Numbers**: Renders `1` (index), `2` (middle), `3` (ring), and `4` (pinky) inside the finger dot.
   * **Open Strings (`O`)**: Displays open ring above strings that sound unfretted.
   * **Muted Strings (`X`)**: Displays a cross above unplayed or muted strings.
   * **Barres**: Draws continuous barre arcs or bars covering frets held by the same finger.
   * **Starting Fret**: Renders position labels (e.g., `3fr` or `5fr`) when voicing is played higher up the neck.
3. **Instantiate from Chord Symbol (`FretboardWidget.fromChord`)**:
   * Create a diagram directly from a string symbol like `'Am'`, `'G7'`, or `'F#m'`.
4. **Pure Dart Audio Playback**:
   * Tap to listen to the chord strummed via synthesized acoustic frequencies.

---

## ⚙️ Properties Table

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`voicing`** *(required in const)* | `ChordVoicing` | — | Voicing model (frets, barres, fingers, string names). |
| **`chordTitle`** | `String?` | `null` | Optional chord name displayed above the diagram. |
| **`fretCount`** | `int` | `5` | Number of visible frets drawn on the board. |
| **`width`** | `double` | `200` | Diagram width in logical pixels. |
| **`height`** | `double` | `230` | Diagram height in logical pixels. |

### `FretboardWidget.fromChord(...)` Factory

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`chordSymbol`** *(required)* | `String` | — | Chord symbol string (e.g., `'C'`, `'Em'`, `'D7'`). |
| **`instrument`** | `InstrumentType` | `InstrumentType.guitar` | Target instrument (`InstrumentType.guitar` or `InstrumentType.ukulele`). |
| **`showTitle`** | `bool` | `false` | Whether to display the chord name above the diagram. |
| **`width`** | `double` | `200` | Diagram width. |
| **`height`** | `double` | `230` | Diagram height. |

---

## 💻 Code Examples

### 1. Guitar Chord Diagram

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class GuitarChordDemo extends StatelessWidget {
  const GuitarChordDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FretboardWidget.fromChord(
        chordSymbol: 'C',
        instrument: InstrumentType.guitar,
        showTitle: true,
        width: 180,
        height: 220,
      ),
    );
  }
}
```
