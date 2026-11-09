# 🏛️ ScaleModesWidget

The **`ScaleModesWidget`** is an interactive theoretical explorer for the **7 Gregorian Church Modes** and **advanced scales** (Pentatonics, Blues, Harmonic Minor, Melodic Minor).

---

## 🎯 Key Features

1. **7 Gregorian Church Modes**:
   * **Ionian** (Major Scale)
   * **Dorian** (Minor with Major 6th)
   * **Phrygian** (Minor with Minor 2nd)
   * **Lydian** (Major with Augmented 4th)
   * **Mixolydian** (Major with Minor 7th)
   * **Aeolian** (Natural Minor Scale)
   * **Locrian** (Diminished with Diminished 5th)
2. **Advanced Scales**:
   * Dedicated tab covering Major Pentatonic, Minor Pentatonic, Blues Scale, Harmonic Minor, and Melodic Minor.
3. **Formula & Note Derivation**:
   * Displays whole/half step intervals (e.g. W - W - H - W - W - W - H) and the exact spelled notes derived from the selected root.
4. **Integrated Piano Keyboard (`showPianoKeyboard`)**:
   * Highlights scale notes on a piano keybed with individual key touch response.
5. **Ascending Scale Audio Playback**:
   * Listen to the complete scale played note-by-note upward using pure Dart audio synthesis.

---

## ⚙️ Properties Table

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`rootNote`** | `String` | `'C'` | Root tonic note for scale generation (e.g., `'C'`, `'A'`, `'F#'`). |
| **`showRootSelector`** | `bool` | `true` | Displays a root selector dropdown to change base key on the fly. |
| **`showPianoKeyboard`** | `bool` | `true` | Shows or hides the interactive piano keyboard below the formula. |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Localization instance for scale names and descriptions. |
| **`onScaleChanged`** | `ValueChanged<ScaleFormula>?` | `null` | Callback triggered when a scale or mode is selected. |

---

## 💻 Code Examples

### 1. Modes Explorer Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class ModesPage extends StatelessWidget {
  const ModesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Church Modes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ScaleModesWidget(
          rootNote: 'D', // Explores D Dorian, D Phrygian, etc.
          showRootSelector: true,
          showPianoKeyboard: true,
          onScaleChanged: (scale) {
            debugPrint('Selected mode: ${scale.name}');
          },
        ),
      ),
    );
  }
}
```
