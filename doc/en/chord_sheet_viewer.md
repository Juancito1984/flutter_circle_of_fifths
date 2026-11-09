# 📝 ChordSheetViewer

The **`ChordSheetViewer`** widget is a high-performance musical lyric viewer designed to render lyrics with aligned chords in **ChordPro** or bracket notation (`[C]Lyric`), featuring a real-time harmonic transposition engine, granular spacing controls, and one-tap chord diagram popups.

---

## 🎯 Key Features

1. **Syllable-Accurate Chord Alignment**: Each chord badge is positioned directly above its associated lyric syllable using a responsive wrapped layout.
2. **Harmonic Transposition Engine**:
   * Step-by-step semitone transposition (`-11` to `+11`).
   * Direct transposition to any key on the **Circle of Fifths** (e.g., from `C` to `F#` or `Eb`), automatically solving enharmonic accidentals (`#` vs `b`).
3. **Granular Spacing & Typography Controls**:
   * Inter-line vertical spacing between consecutive song lines (`lineSpacing`).
   * Inter-stanza vertical spacing between verses separated by empty lines (`stanzaSpacing`).
   * Vertical distance between chord badge and lyric text (`chordToLyricSpacing`).
   * Word gap spacing (`wordSpacing`) and wrap run spacing (`lineRunSpacing`).
4. **Lyrics-Only Mode (`showChords`)**:
   * Toggle between showing chords and lyrics-only mode.
   * When `showChords: false`, renders the song as continuous native text optimized for clean reading and selection.
5. **Built-in Chord Inspector**:
   * Tapping any chord automatically opens [`ChordInspectorSheet`](chord_inspector_sheet.md) with interactive diagrams for **Guitar**, **Ukulele**, and **Piano**, plus audio synthesis.
6. **Full Localization (i18n)**:
   * Compatible with [`CircleOfFifthsLabels`](../../lib/src/theme/circle_of_fifths_labels.dart) to customize or translate toolbar labels, semitone controls, and modal titles.

---

## 🛠 Input Format Syntax (`songText`)

The widget parses plain text containing chords enclosed in brackets:

```text
[G]Amazing grace, how [C]sweet the [G]sound
That saved a wretch like [D]me!
I [G]once was lost, but [C]now am [G]found,
Was [Em]blind, but [D]now I [G]see.

[G]Twas grace that taught my [C]heart to [G]fear,
And grace my fears re[D]lieved.
```

* **Section Headers**: Lines matching labels such as `[Verse 1]`, `[Chorus]`, `[Intro]`, `[Bridge]` are styled using `sectionStyle`.
* **Empty Lines**: Treated as stanza breaks and spaced according to `stanzaSpacing`.
* **Slash Chords**: Supports compound/inverted bass chords like `[C/G]`, `[D/F#]`, `[Am7/G]`.

---

## ⚙️ Properties Table

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`songText`** *(required)* | `String` | — | Song text in ChordPro / bracket notation (`"[G]Amazing [C]grace..."`). |
| **`originalKey`** | `String?` | `'C'` | Original musical key of the song. Used as the reference baseline for Circle of Fifths synchronization. |
| **`initialTransposeSemitones`** | `int` | `0` | Initial semitone transposition offset (`-11` to `+11`). |
| **`targetKey`** | `String?` | `null` | External target key from the Circle of Fifths (e.g. `'G'`, `'Eb'`). Computes semitones and enharmonic spelling automatically. |
| **`showChords`** | `bool` | `true` | Whether to display chords above lyrics. If `false`, hides chord badges, upper margins, and toolbar. |
| **`showTranspositionBar`** | `bool` | `true` | Whether to show the top toolbar with semitone step buttons (`-`, `0`, `+`) and key dropdown. |
| **`showChordSummaryBar`** | `bool` | `true` | Displays a scrollable horizontal row containing all unique chords used in the song. |
| **`showDiagramModalOnTap`** | `bool` | `true` | If `true`, tapping any chord opens the inspector modal with Guitar, Ukulele, and Piano diagrams. |
| **`defaultInstrument`** | `InstrumentType` | `InstrumentType.guitar` | Default instrument tab displayed when opening the chord inspector modal. |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Localization instance for all user-facing strings. |
| **`lineSpacing`** | `double` | `8.0` | Vertical space between consecutive song lines within a stanza. |
| **`stanzaSpacing`** | `double` | `16.0` | Vertical space between stanzas (groups of lines separated by empty lines). |
| **`chordToLyricSpacing`** | `double` | `2.0` | Vertical distance between the bottom of the chord badge and the lyric syllable. |
| **`wordSpacing`** | `double` | `4.0` | Horizontal spacing between word chunks in a line. |
| **`lineRunSpacing`** | `double` | `8.0` | Vertical spacing between wrapped rows when a long line wraps physically. |
| **`lyricStyle`** | `TextStyle?` | `fontSize: 16, height: 1.2` | Text style for song lyrics. |
| **`chordStyle`** | `TextStyle?` | `fontSize: 13, bold, primaryColor` | Text style for chord badges. |
| **`sectionStyle`** | `TextStyle?` | `fontSize: 13, bold, secondaryColor` | Text style for section headers (`[Intro]`, `[Chorus]`, etc.). |
| **`onTapChord`** | `ValueChanged<ChordInfo>?` | `null` | Callback triggered when a chord badge is tapped, returning its `ChordInfo`. |
| **`onTransposeChanged`** | `ValueChanged<int>?` | `null` | Callback notifying whenever the transposition semitone offset changes. |

---

## 💻 Code Examples

### 1. Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class SongViewerPage extends StatelessWidget {
  const SongViewerPage({super.key});

  final String song = '''
[G]Amazing grace, how [C]sweet the [G]sound
That saved a wretch like [D]me!
I [G]once was lost, but [C]now am [G]found,
Was [Em]blind, but [D]now I [G]see.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Song Sheet')),
      body: ChordSheetViewer(
        songText: song,
        originalKey: 'G',
      ),
    );
  }
}
```

---

### 2. Custom Line and Stanza Spacing

```dart
ChordSheetViewer(
  songText: song,
  originalKey: 'C',
  lineSpacing: 6.0,          // Distance between consecutive verses
  stanzaSpacing: 24.0,       // Generous spacing between stanzas
  chordToLyricSpacing: 3.0,  // Distance between chord badge and text
  wordSpacing: 6.0,
)
```

---

### 3. Lyrics-Only Mode (`showChords: false`)

```dart
ChordSheetViewer(
  songText: song,
  originalKey: 'C',
  showChords: false,         // Clean lyrics without chord badges or toolbar
  lineSpacing: 8.0,
  stanzaSpacing: 20.0,
  lyricStyle: const TextStyle(
    fontSize: 18,
    height: 1.4,
    color: Colors.black87,
  ),
)
```
