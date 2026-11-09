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
4. **Decoupled Touch Interaction (`onNoteTap`)**:
   * Detects precise key taps and provides the played note (e.g., `'C4'`, `'G4'`).
   * To keep this package 100% pure Dart and maintain 160/160 pub points without native audio dependencies, you can route `onNoteTap` directly to the included in-memory synthesizer ([`SimpleAudioSynthesizer`](../../lib/src/audio/simple_audio_synthesizer.dart)) using your preferred audio backend (`audioplayers`, `just_audio`, etc.).

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

### 1. C Major Triad (C - E - G) with Audio Playback

```dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class PianoChordDemo extends StatefulWidget {
  const PianoChordDemo({super.key});

  @override
  State<PianoChordDemo> createState() => _PianoChordDemoState();
}

class _PianoChordDemoState extends State<PianoChordDemo> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playNote(String note) async {
    // Generate pure PCM WAV bytes in memory
    final wavBytes = SimpleAudioSynthesizer.synthesizeChordNotes([note]);
    if (wavBytes.isNotEmpty) {
      await _player.stop();
      await _player.play(BytesSource(wavBytes));
    }
  }

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
          onNoteTap: (note) => _playNote(note),
        ),
      ),
    );
  }
}
```
