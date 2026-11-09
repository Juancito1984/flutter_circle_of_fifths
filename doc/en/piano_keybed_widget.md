# 🎹 PianoKeybedWidget

The **`PianoKeybedWidget`** is an interactive vector piano keyboard that renders 1 to 3 octavas, highlighting the notes of any chord, scale, or mode.

---

## 🎯 Key Features

1. **1 to 3 Octaves Display**:
   * Displays 1 octave (12 keys), 2 octaves (24 keys), or 3 octaves (36 keys), scaling smoothly to parent width constraints.
2. **Harmonic Note Highlighting**:
   * Active keys are highlighted using primary theme colors.
   * Root tonic note (`rootNote`) can be accented with a distinct color to anchor the base of the chord or scale.
3. **Note Key Labels (`showNoteLabels`)**:
   * Renders note names on active keys (`C`, `D`, `E`, etc.).
   * Supports flat preference (`preferFlats: true` to display `Db`, `Eb`, `Gb`, `Ab`, `Bb`).
4. **Touch Interaction & Sound (`onNoteTap`)**:
   * Play any piano key with built-in pure Dart sound synthesis or attach custom interactive logic.

---

## ⚙️ Properties Table

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`highlightedNotes`** *(required)* | `List<String>` | — | List of note names to highlight (e.g., `['C', 'E', 'G']`). |
| **`rootNote`** | `String?` | `null` | Root tonic note name accented with a special color. |
| **`octaves`** | `int` | `2` | Number of visible octaves (`1`, `2`, or `3`). |
| **`showNoteLabels`** | `bool` | `true` | Whether to paint note names on active keys. |
| **`preferFlats`** | `bool` | `false` | If `true`, formats accidentals with flats (`Db`, `Eb`) instead of sharps (`C#`, `D#`). |
| **`height`** | `double` | `150` | Height of the piano keybed in pixels. |
| **`onNoteTap`** | `ValueChanged<String>?` | `null` | Callback triggered when a key is tapped, delivering its note name. |

---

## 💻 Code Examples

### 1. C Major Triad (C - E - G) on 2 Octaves

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class PianoChordDemo extends StatelessWidget {
  const PianoChordDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PianoKeybedWidget(
          highlightedNotes: const ['C', 'E', 'G'],
          rootNote: 'C',
          octaves: 2,
          showNoteLabels: true,
          height: 140,
        ),
      ),
    );
  }
}
```
