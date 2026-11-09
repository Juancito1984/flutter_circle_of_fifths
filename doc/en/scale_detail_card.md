# 🎴 ScaleDetailCard

The **`ScaleDetailCard`** widget is a comprehensive theoretical breakdown card that displays the anatomy of any diatonic key: degree numbers, interval formula, primary/secondary chords, and an optional interactive piano keybed.

---

## 🎯 Key Features

1. **7 Diatonic Degrees Breakdown**:
   * Displays scale notes numbered **I through VII** with whole/half step interval indicators (W-W-H-W-W-W-H).
2. **Harmonic Quality Identification**:
   * Distinguishes Major, Minor, and Diminished chords corresponding to each scale degree.
3. **One-Tap Chord Inspection (`enableChordTap`)**:
   * Tapping any scale degree button pops up [`ChordInspectorSheet`](chord_inspector_sheet.md) with Guitar, Ukulele, and Piano voicings.
4. **Interactive Piano Keybed (`showPianoScale`)**:
   * Renders a piano keyboard highlighting the active scale notes with pure Dart sound synthesis.
5. **Major and Minor Scale Support**:
   * Adapts scale notes and intervals dynamically when `isMinorMode: true`.

---

## ⚙️ Properties Table

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`model`** *(required)* | `CircleOfFifthsModel` | — | Data model providing scale notes, tonic, relative minor, and accidentals. |
| **`isMinorMode`** | `bool` | `false` | Whether to display the Major scale (`false`) or the Relative Minor scale (`true`). |
| **`showPianoScale`** | `bool` | `false` | Whether to render an interactive piano keyboard highlighting scale notes. |
| **`enableChordTap`** | `bool` | `true` | Enables tapping scale degrees to inspect their chord diagrams in instruments. |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Localization instance for section headers and degree descriptions. |

---

## 💻 Code Examples

### 1. Embedded Scale Card

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class ScaleOverviewPage extends StatelessWidget {
  const ScaleOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modelG = CircleOfFifthsModel.defaultKeys[1]; // G Major

    return Scaffold(
      appBar: AppBar(title: const Text('G Major Scale')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ScaleDetailCard(
          model: modelG,
          isMinorMode: false,
          showPianoScale: true,
        ),
      ),
    );
  }
}
```
