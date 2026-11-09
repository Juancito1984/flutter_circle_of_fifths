# 🎼 ProgressionBuilderWidget

The **`ProgressionBuilderWidget`** is an interactive laboratory for analyzing, building, and playing harmonic chord progressions in Roman numerals (`I`, `ii`, `IV`, `V`), fully synchronized with the Circle of Fifths.

---

## 🎯 Key Features

1. **Standard Progression Templates**:
   * *Axis of Awesome / Pop*: `I - V - vi - IV`
   * *Jazz Standard*: `ii - V - I`
   * *12-Bar Blues*: Traditional 12-bar dominant 7th blues structure.
   * *Pachelbel's Canon*: `I - V - vi - iii - IV - I - IV - V`
   * *50s Doo-Wop*: `I - vi - IV - V`
   * *Andalusian Cadence / Flamenco*: `i - VII - VI - V`
2. **Roman Numeral Degree Analysis**:
   * Automatically resolves generic degrees into concrete chords for the chosen key (e.g. in `C`, `I` = `C`, `V` = `G`; in `G`, `I` = `G`, `V` = `D`).
3. **Passing Chords & Modulation Suggestions**:
   * Suggests secondary dominants (`V/V`, `V/vi`) and borrowed modal interchange chords.
4. **Rhythmic Progression Player**:
   * Listen to the progression measure by measure with synchronized synthesized chord audio.
5. **One-Tap Voicing Inspection**:
   * Tapping any progression step opens [`ChordInspectorSheet`](chord_inspector_sheet.md) with Guitar, Ukulele, and Piano diagrams.

---

## ⚙️ Properties Table

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`activeKey`** | `String` | `'C'` | Harmonic baseline key (e.g., `'C'`, `'G'`, `'Eb'`). |
| **`showKeySelector`** | `bool` | `true` | Displays a dropdown to change the active key directly. |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Localization instance for headers, suggestions, and buttons. |
| **`onChordTap`** | `ValueChanged<String>?` | `null` | Callback triggered when a chord in the progression is tapped. |

---

## 💻 Code Examples

### 1. Embedded Progression Builder

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class ProgressionPage extends StatelessWidget {
  const ProgressionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Harmonic Progressions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ProgressionBuilderWidget(
          activeKey: 'D',
          onChordTap: (chord) {
            debugPrint('Tapped chord: $chord');
          },
        ),
      ),
    );
  }
}
```
