import 'circle_of_fifths_model.dart';

/// Supported musical instruments for chord diagrams.
enum InstrumentType {
  /// 6-string standard tuned guitar (E A D G B E).
  guitar,

  /// 4-string standard tuned soprano/concert/tenor ukulele (G C E A).
  ukulele,

  /// Standard 12-key per octave piano keyboard.
  piano,
}

/// Represents a barre (cejilla) across multiple strings on a fretted instrument.
class ChordBarre {
  /// Fret number (relative to [ChordVoicing.baseFret], 1-based).
  final int fret;

  /// First string index covered by the barre (0 = lowest pitch string).
  final int startString;

  /// Last string index covered by the barre.
  final int endString;

  /// Finger number used for the barre (1 = index, 2 = middle, 3 = ring, 4 = pinky).
  final int finger;

  /// Creates a [ChordBarre] configuration.
  const ChordBarre({
    required this.fret,
    required this.startString,
    required this.endString,
    this.finger = 1,
  });
}

/// Represents a fingerboard voicing for a fretted instrument (Guitar or Ukulele).
class ChordVoicing {
  /// Fret positions for each string from lowest to highest string.
  /// `-1` indicates a muted string (`X`), `0` indicates an open string (`O`),
  /// and positive integers indicate the relative fret number (1..5).
  final List<int> frets;

  /// Finger numbers for each string (`0` = none/open/muted, `1`..`4` = index..pinky).
  final List<int> fingers;

  /// Starting fret of the diagram (defaults to `1` for open position chords).
  final int baseFret;

  /// Optional list of barre (cejilla) definitions.
  final List<ChordBarre> barres;

  /// Tuning labels for the strings from left to right.
  final List<String> stringNames;

  /// Creates a [ChordVoicing] for a fretted instrument.
  const ChordVoicing({
    required this.frets,
    required this.fingers,
    this.baseFret = 1,
    this.barres = const [],
    required this.stringNames,
  });

  /// Standard 6-string guitar tuning names.
  static const List<String> guitarStrings = ['E', 'A', 'D', 'G', 'B', 'E'];

  /// Standard 4-string ukulele tuning names.
  static const List<String> ukuleleStrings = ['G', 'C', 'E', 'A'];
}

/// Contains parsed music theory data, notes, and instrument voicings for a chord.
class ChordInfo {
  /// Complete chord symbol as displayed (e.g., `"G7"`, `"F#m"`, `"C/G"`).
  final String symbol;

  /// Root note of the chord (e.g., `"G"`, `"F#"`).
  final String root;

  /// Chord quality suffix (e.g., `""` for major, `"m"`, `"7"`, `"maj7"`, `"sus4"`, `"dim"`).
  final String quality;

  /// Optional slash bass note (e.g., `"G"` in `"C/G"`).
  final String? bassNote;

  /// Individual pitch class notes that form the chord (e.g., `['G', 'B', 'D', 'F']`).
  final List<String> notes;

  /// Semitone intervals from the root note (e.g., `[0, 4, 7, 10]` for dominant 7th).
  final List<int> semitoneIntervals;

  /// Interval formula labels (e.g., `['1', '3', '5', 'b7']`).
  final List<String> intervalLabels;

  /// Standard 6-string Guitar voicing for this chord.
  final ChordVoicing guitarVoicing;

  /// Standard 4-string Ukulele voicing for this chord.
  final ChordVoicing ukuleleVoicing;

  /// Creates a [ChordInfo] instance with complete harmonic and diagram data.
  const ChordInfo({
    required this.symbol,
    required this.root,
    required this.quality,
    this.bassNote,
    required this.notes,
    required this.semitoneIntervals,
    required this.intervalLabels,
    required this.guitarVoicing,
    required this.ukuleleVoicing,
  });
}

/// Engine for parsing chords, computing chord notes/voicings, and transposing
/// chords and songs using the Circle of Fifths.
class ChordTransposer {
  ChordTransposer._();

  /// Sharp chromatic scale names.
  static const List<String> sharpScale = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  /// Flat chromatic scale names.
  static const List<String> flatScale = [
    'C',
    'Db',
    'D',
    'Eb',
    'E',
    'F',
    'Gb',
    'G',
    'Ab',
    'A',
    'Bb',
    'B',
  ];

  static const Map<String, int> _noteToIndex = {
    'C': 0,
    'B#': 0,
    'C#': 1,
    'Db': 1,
    'D': 2,
    'D#': 3,
    'Eb': 3,
    'E': 4,
    'Fb': 4,
    'F': 5,
    'E#': 5,
    'F#': 6,
    'Gb': 6,
    'G': 7,
    'G#': 8,
    'Ab': 8,
    'A': 9,
    'A#': 10,
    'Bb': 10,
    'B': 11,
    'Cb': 11,
  };

  static final RegExp _chordRegex = RegExp(
    r'^([A-G][#b♯♭]?)(.*?)(?:/([A-G][#b♯♭]?))?$',
  );

  /// Converts a musical note string (e.g., `"C#"`, `"Bb"`) to its chromatic index (0..11).
  /// Returns `-1` if the string is not a valid note.
  static int noteToSemitone(String note) {
    if (note.isEmpty) return -1;
    final clean = note.trim().replaceAll('♯', '#').replaceAll('♭', 'b');
    final normalized = clean.length > 1
        ? '${clean[0].toUpperCase()}${clean.substring(1)}'
        : clean.toUpperCase();
    return _noteToIndex[normalized] ?? -1;
  }

  /// Converts a chromatic index (0..11) to a note name using sharps or flats.
  static String semitoneToNote(int semitone, {bool preferFlats = false}) {
    final idx = ((semitone % 12) + 12) % 12;
    return preferFlats ? flatScale[idx] : sharpScale[idx];
  }

  /// Determines whether a target key from the Circle of Fifths uses flat notation.
  static bool prefersFlatsForKey(String? keyName) {
    if (keyName == null || keyName.isEmpty) return false;
    final cleaned = keyName.trim().replaceAll('♯', '#').replaceAll('♭', 'b');
    if (cleaned.contains('b')) return true;
    if (cleaned.contains('#')) return false;

    for (final model in CircleOfFifthsModel.defaultKeys) {
      if (model.major.toLowerCase() == cleaned.toLowerCase() ||
          model.minor.toLowerCase() ==
              cleaned.toLowerCase().replaceAll('m', '')) {
        return model.keySignature.contains('b');
      }
    }
    return cleaned == 'F' || cleaned == 'd' || cleaned == 'Dm';
  }

  /// Calculates the semitone distance required to transpose from [sourceKey] to [targetKey].
  static int semitonesBetweenKeys(String sourceKey, String targetKey) {
    final fromRoot = _extractKeyRoot(sourceKey);
    final toRoot = _extractKeyRoot(targetKey);
    final fromIdx = noteToSemitone(fromRoot);
    final toIdx = noteToSemitone(toRoot);
    if (fromIdx == -1 || toIdx == -1) return 0;
    int diff = (toIdx - fromIdx) % 12;
    if (diff > 6) diff -= 12;
    if (diff < -6) diff += 12;
    return diff;
  }

  static String _extractKeyRoot(String key) {
    final match = RegExp(r'^([A-Ga-g][#b♯♭]?)').firstMatch(key.trim());
    if (match == null) return key;
    final raw = match.group(1)!;
    return raw.length > 1
        ? '${raw[0].toUpperCase()}${raw.substring(1)}'
        : raw.toUpperCase();
  }

  /// Transposes a single chord symbol (e.g., `"G7"`, `"D/F#"`) by [semitones].
  /// Automatically adapts enharmonic spelling (`#` vs `b`) when [targetKey] or [preferFlats] is given.
  static String transposeChord(
    String chordSymbol,
    int semitones, {
    bool? preferFlats,
    String? targetKey,
  }) {
    final trimmed = chordSymbol.trim();
    final match = _chordRegex.firstMatch(trimmed);
    if (match == null) return chordSymbol;

    final root = match.group(1)!;
    final quality = match.group(2) ?? '';
    final bass = match.group(3);

    final rootIndex = noteToSemitone(root);
    if (rootIndex == -1) return chordSymbol;

    final newRootIndex = ((rootIndex + semitones) % 12 + 12) % 12;
    final useFlats = preferFlats ??
        (targetKey != null
            ? prefersFlatsForKey(targetKey)
            : (root.contains('b') ||
                root.contains('♭') ||
                newRootIndex == 5 ||
                newRootIndex == 10));

    final newRoot = semitoneToNote(newRootIndex, preferFlats: useFlats);

    if (bass != null && bass.isNotEmpty) {
      final bassIndex = noteToSemitone(bass);
      if (bassIndex != -1) {
        final newBass = semitoneToNote(
          bassIndex + semitones,
          preferFlats: useFlats,
        );
        return '$newRoot$quality/$newBass';
      }
    }

    return '$newRoot$quality';
  }

  /// Transposes all bracketed chords (e.g., `[C]Amazing [F]grace`) inside [chordProText].
  static String transposeLyrics(
    String chordProText,
    int semitones, {
    bool? preferFlats,
    String? targetKey,
  }) {
    if (semitones == 0 && targetKey == null && preferFlats == null) {
      return chordProText;
    }
    return chordProText.replaceAllMapped(RegExp(r'\[([^\[\]]+)\]'), (match) {
      final content = match.group(1)!;
      if (!isChordSymbol(content)) {
        return match.group(0)!;
      }
      final transposed = transposeChord(
        content,
        semitones,
        preferFlats: preferFlats,
        targetKey: targetKey,
      );
      return '[$transposed]';
    });
  }

  /// Returns `true` if [token] is a valid musical chord symbol rather than a section label like `Chorus`.
  static bool isChordSymbol(String token) {
    final trimmed = token.trim();
    if (trimmed.isEmpty) return false;
    final match = _chordRegex.firstMatch(trimmed);
    if (match == null) return false;
    final quality = match.group(2) ?? '';
    const validQualities = {
      '',
      'm',
      'min',
      '-',
      'M',
      'maj',
      '7',
      'M7',
      'maj7',
      'm7',
      'min7',
      '-7',
      'dim',
      'dim7',
      'o',
      'o7',
      '°',
      '°7',
      'aug',
      '+',
      'sus',
      'sus2',
      'sus4',
      '7sus4',
      '6',
      'm6',
      '9',
      'm9',
      'maj9',
      'add9',
      'add2',
      '5',
      '11',
      '13',
      'm7b5',
      'ø',
    };
    return validQualities.contains(quality);
  }

  /// Parses a chord symbol into a full [ChordInfo] containing its notes, intervals,
  /// and instrument voicings for Guitar, Ukulele, and Piano.
  static ChordInfo parseChord(String chordSymbol, {bool? preferFlats}) {
    final trimmed = chordSymbol.trim();
    final match = _chordRegex.firstMatch(trimmed);

    if (match == null) {
      return _buildChordInfo(
        symbol: trimmed.isEmpty ? 'C' : trimmed,
        root: 'C',
        quality: '',
        bassNote: null,
        preferFlats: preferFlats ?? false,
      );
    }

    final rawRoot = match.group(1)!;
    final quality = match.group(2) ?? '';
    final bassNote = match.group(3);
    final useFlats = preferFlats ??
        (rawRoot.contains('b') || rawRoot.contains('♭') || rawRoot == 'F');

    final rootSemitone = noteToSemitone(rawRoot);
    final normalizedRoot = semitoneToNote(
      rootSemitone == -1 ? 0 : rootSemitone,
      preferFlats: useFlats,
    );

    return _buildChordInfo(
      symbol: trimmed,
      root: normalizedRoot,
      quality: quality,
      bassNote: bassNote,
      preferFlats: useFlats,
    );
  }

  static ChordInfo _buildChordInfo({
    required String symbol,
    required String root,
    required String quality,
    required String? bassNote,
    required bool preferFlats,
  }) {
    final rootIndex = noteToSemitone(root);
    final (intervals, labels, canonicalQuality) = _intervalsForQuality(quality);

    final notes = intervals
        .map((semi) =>
            semitoneToNote(rootIndex + semi, preferFlats: preferFlats))
        .toList();

    if (bassNote != null && bassNote.isNotEmpty) {
      final bassSemi = noteToSemitone(bassNote);
      if (bassSemi != -1) {
        final formattedBass =
            semitoneToNote(bassSemi, preferFlats: preferFlats);
        if (!notes.contains(formattedBass)) {
          notes.insert(0, formattedBass);
        }
      }
    }

    final guitarVoicing = _resolveGuitarVoicing(rootIndex, canonicalQuality);
    final ukuleleVoicing = _resolveUkuleleVoicing(rootIndex, canonicalQuality);

    return ChordInfo(
      symbol: symbol,
      root: root,
      quality: quality,
      bassNote: bassNote,
      notes: notes,
      semitoneIntervals: intervals,
      intervalLabels: labels,
      guitarVoicing: guitarVoicing,
      ukuleleVoicing: ukuleleVoicing,
    );
  }

  static (List<int>, List<String>, String) _intervalsForQuality(String q) {
    switch (q) {
      case 'm':
      case 'min':
      case '-':
        return ([0, 3, 7], ['1', 'b3', '5'], 'm');
      case '7':
        return ([0, 4, 7, 10], ['1', '3', '5', 'b7'], '7');
      case 'maj7':
      case 'M7':
        return ([0, 4, 7, 11], ['1', '3', '5', '7'], 'maj7');
      case 'm7':
      case 'min7':
      case '-7':
        return ([0, 3, 7, 10], ['1', 'b3', '5', 'b7'], 'm7');
      case 'sus2':
        return ([0, 2, 7], ['1', '2', '5'], 'sus2');
      case 'sus4':
      case 'sus':
        return ([0, 5, 7], ['1', '4', '5'], 'sus4');
      case '7sus4':
        return ([0, 5, 7, 10], ['1', '4', '5', 'b7'], 'sus4');
      case 'dim':
      case 'o':
      case '°':
      case 'dis':
        return ([0, 3, 6], ['1', 'b3', 'b5'], 'dim');
      case 'dim7':
      case 'o7':
      case '°7':
        return ([0, 3, 6, 9], ['1', 'b3', 'b5', 'bb7'], 'dim');
      case 'm7b5':
      case 'ø':
        return ([0, 3, 6, 10], ['1', 'b3', 'b5', 'b7'], 'dim');
      case 'aug':
      case '+':
        return ([0, 4, 8], ['1', '3', '#5'], 'aug');
      case '6':
        return ([0, 4, 7, 9], ['1', '3', '5', '6'], '');
      case 'm6':
        return ([0, 3, 7, 9], ['1', 'b3', '5', '6'], 'm');
      case 'add9':
      case 'add2':
        return ([0, 4, 7, 2], ['1', '3', '5', '9'], '');
      case '9':
        return ([0, 4, 7, 10, 2], ['1', '3', '5', 'b7', '9'], '7');
      case '5':
        return ([0, 7], ['1', '5'], '');
      default:
        return ([0, 4, 7], ['1', '3', '5'], '');
    }
  }

  /// Resolves a realistic 6-string guitar voicing for [rootSemitone] (0=C..11=B) and [quality].
  static ChordVoicing _resolveGuitarVoicing(int rootSemitone, String quality) {
    final key = '${sharpScale[rootSemitone % 12]}_$quality';
    final predefined = _openGuitarVoicings[key];
    if (predefined != null) {
      return predefined;
    }

    // Algorithmic movable E-shape or A-shape barre voicing fallback
    // E string = 4 (E), A string = 9 (A)
    final fretOnA = ((rootSemitone - 9) % 12 + 12) % 12;
    final fretOnE = ((rootSemitone - 4) % 12 + 12) % 12;

    if (fretOnA > 0 && fretOnA <= 7) {
      final base = fretOnA;
      switch (quality) {
        case 'm':
          return ChordVoicing(
            frets: const [-1, 1, 3, 3, 2, 1],
            fingers: const [0, 1, 3, 4, 2, 1],
            baseFret: base,
            barres: const [ChordBarre(fret: 1, startString: 1, endString: 5)],
            stringNames: ChordVoicing.guitarStrings,
          );
        case '7':
          return ChordVoicing(
            frets: const [-1, 1, 3, 1, 3, 1],
            fingers: const [0, 1, 3, 1, 4, 1],
            baseFret: base,
            barres: const [ChordBarre(fret: 1, startString: 1, endString: 5)],
            stringNames: ChordVoicing.guitarStrings,
          );
        case 'maj7':
          return ChordVoicing(
            frets: const [-1, 1, 3, 2, 3, 1],
            fingers: const [0, 1, 3, 2, 4, 1],
            baseFret: base,
            barres: const [ChordBarre(fret: 1, startString: 1, endString: 5)],
            stringNames: ChordVoicing.guitarStrings,
          );
        case 'm7':
          return ChordVoicing(
            frets: const [-1, 1, 3, 1, 2, 1],
            fingers: const [0, 1, 3, 1, 2, 1],
            baseFret: base,
            barres: const [ChordBarre(fret: 1, startString: 1, endString: 5)],
            stringNames: ChordVoicing.guitarStrings,
          );
        case 'sus2':
          return ChordVoicing(
            frets: const [-1, 1, 3, 3, 1, 1],
            fingers: const [0, 1, 3, 4, 1, 1],
            baseFret: base,
            barres: const [ChordBarre(fret: 1, startString: 1, endString: 5)],
            stringNames: ChordVoicing.guitarStrings,
          );
        case 'sus4':
          return ChordVoicing(
            frets: const [-1, 1, 3, 3, 4, 1],
            fingers: const [0, 1, 2, 3, 4, 1],
            baseFret: base,
            barres: const [ChordBarre(fret: 1, startString: 1, endString: 5)],
            stringNames: ChordVoicing.guitarStrings,
          );
        case 'dim':
          return ChordVoicing(
            frets: const [-1, 1, 2, 3, 2, -1],
            fingers: const [0, 1, 2, 4, 3, 0],
            baseFret: base,
            stringNames: ChordVoicing.guitarStrings,
          );
        default:
          return ChordVoicing(
            frets: const [-1, 1, 3, 3, 3, 1],
            fingers: const [0, 1, 2, 3, 4, 1],
            baseFret: base,
            barres: const [ChordBarre(fret: 1, startString: 1, endString: 5)],
            stringNames: ChordVoicing.guitarStrings,
          );
      }
    }

    final base = fretOnE == 0 ? 1 : fretOnE;
    switch (quality) {
      case 'm':
        return ChordVoicing(
          frets: const [1, 3, 3, 1, 1, 1],
          fingers: const [1, 3, 4, 1, 1, 1],
          baseFret: base,
          barres: const [ChordBarre(fret: 1, startString: 0, endString: 5)],
          stringNames: ChordVoicing.guitarStrings,
        );
      case '7':
        return ChordVoicing(
          frets: const [1, 3, 1, 2, 1, 1],
          fingers: const [1, 3, 1, 2, 1, 1],
          baseFret: base,
          barres: const [ChordBarre(fret: 1, startString: 0, endString: 5)],
          stringNames: ChordVoicing.guitarStrings,
        );
      case 'm7':
        return ChordVoicing(
          frets: const [1, 3, 1, 1, 1, 1],
          fingers: const [1, 3, 1, 1, 1, 1],
          baseFret: base,
          barres: const [ChordBarre(fret: 1, startString: 0, endString: 5)],
          stringNames: ChordVoicing.guitarStrings,
        );
      default:
        return ChordVoicing(
          frets: const [1, 3, 3, 2, 1, 1],
          fingers: const [1, 3, 4, 2, 1, 1],
          baseFret: base,
          barres: const [ChordBarre(fret: 1, startString: 0, endString: 5)],
          stringNames: ChordVoicing.guitarStrings,
        );
    }
  }

  /// Resolves a 4-string Ukulele (G C E A) voicing for [rootSemitone] and [quality].
  static ChordVoicing _resolveUkuleleVoicing(int rootSemitone, String quality) {
    final key = '${sharpScale[rootSemitone % 12]}_$quality';
    final predefined = _ukuleleVoicings[key];
    if (predefined != null) {
      return predefined;
    }

    // Algorithmic movable ukulele voicing based on C-shape / F-shape
    final offset = rootSemitone % 12;
    final base = offset == 0 ? 1 : offset;
    switch (quality) {
      case 'm':
        return ChordVoicing(
          frets: const [1, 4, 4, 4],
          fingers: const [1, 2, 3, 4],
          baseFret: base,
          stringNames: ChordVoicing.ukuleleStrings,
        );
      case '7':
        return ChordVoicing(
          frets: const [1, 1, 1, 2],
          fingers: const [1, 1, 1, 2],
          baseFret: base,
          barres: const [ChordBarre(fret: 1, startString: 0, endString: 2)],
          stringNames: ChordVoicing.ukuleleStrings,
        );
      case 'm7':
        return ChordVoicing(
          frets: const [1, 4, 4, 2],
          fingers: const [1, 3, 4, 2],
          baseFret: base,
          stringNames: ChordVoicing.ukuleleStrings,
        );
      case 'maj7':
        return ChordVoicing(
          frets: const [1, 1, 1, 3],
          fingers: const [1, 1, 1, 3],
          baseFret: base,
          barres: const [ChordBarre(fret: 1, startString: 0, endString: 2)],
          stringNames: ChordVoicing.ukuleleStrings,
        );
      case 'sus4':
        return ChordVoicing(
          frets: const [1, 1, 2, 4],
          fingers: const [1, 1, 2, 4],
          baseFret: base,
          barres: const [ChordBarre(fret: 1, startString: 0, endString: 1)],
          stringNames: ChordVoicing.ukuleleStrings,
        );
      case 'dim':
        return ChordVoicing(
          frets: const [2, 3, 2, 3],
          fingers: const [1, 3, 2, 4],
          baseFret: base,
          stringNames: ChordVoicing.ukuleleStrings,
        );
      default:
        return ChordVoicing(
          frets: const [1, 1, 1, 4],
          fingers: const [1, 1, 1, 4],
          baseFret: base,
          barres: const [ChordBarre(fret: 1, startString: 0, endString: 2)],
          stringNames: ChordVoicing.ukuleleStrings,
        );
    }
  }

  static const Map<String, ChordVoicing> _openGuitarVoicings = {
    // C family
    'C_': ChordVoicing(
      frets: [-1, 3, 2, 0, 1, 0],
      fingers: [0, 3, 2, 0, 1, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'C_7': ChordVoicing(
      frets: [-1, 3, 2, 3, 1, 0],
      fingers: [0, 3, 2, 4, 1, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'C_maj7': ChordVoicing(
      frets: [-1, 3, 2, 0, 0, 0],
      fingers: [0, 3, 2, 0, 0, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'C_sus4': ChordVoicing(
      frets: [-1, 3, 3, 0, 1, 1],
      fingers: [0, 3, 4, 0, 1, 1],
      stringNames: ChordVoicing.guitarStrings,
    ),
    // D family
    'D_': ChordVoicing(
      frets: [-1, -1, 0, 2, 3, 2],
      fingers: [0, 0, 0, 1, 3, 2],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'D_m': ChordVoicing(
      frets: [-1, -1, 0, 2, 3, 1],
      fingers: [0, 0, 0, 2, 3, 1],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'D_7': ChordVoicing(
      frets: [-1, -1, 0, 2, 1, 2],
      fingers: [0, 0, 0, 2, 1, 3],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'D_maj7': ChordVoicing(
      frets: [-1, -1, 0, 2, 2, 2],
      fingers: [0, 0, 0, 1, 2, 3],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'D_m7': ChordVoicing(
      frets: [-1, -1, 0, 2, 1, 1],
      fingers: [0, 0, 0, 2, 1, 1],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'D_sus2': ChordVoicing(
      frets: [-1, -1, 0, 2, 3, 0],
      fingers: [0, 0, 0, 1, 3, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'D_sus4': ChordVoicing(
      frets: [-1, -1, 0, 2, 3, 3],
      fingers: [0, 0, 0, 1, 3, 4],
      stringNames: ChordVoicing.guitarStrings,
    ),
    // E family
    'E_': ChordVoicing(
      frets: [0, 2, 2, 1, 0, 0],
      fingers: [0, 2, 3, 1, 0, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'E_m': ChordVoicing(
      frets: [0, 2, 2, 0, 0, 0],
      fingers: [0, 2, 3, 0, 0, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'E_7': ChordVoicing(
      frets: [0, 2, 0, 1, 0, 0],
      fingers: [0, 2, 0, 1, 0, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'E_m7': ChordVoicing(
      frets: [0, 2, 0, 0, 0, 0],
      fingers: [0, 2, 0, 0, 0, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'E_sus4': ChordVoicing(
      frets: [0, 2, 2, 2, 0, 0],
      fingers: [0, 2, 3, 4, 0, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    // F family
    'F_': ChordVoicing(
      frets: [1, 3, 3, 2, 1, 1],
      fingers: [1, 3, 4, 2, 1, 1],
      barres: [ChordBarre(fret: 1, startString: 0, endString: 5)],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'F_maj7': ChordVoicing(
      frets: [-1, -1, 3, 2, 1, 0],
      fingers: [0, 0, 3, 2, 1, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    // G family
    'G_': ChordVoicing(
      frets: [3, 2, 0, 0, 0, 3],
      fingers: [2, 1, 0, 0, 0, 3],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'G_7': ChordVoicing(
      frets: [3, 2, 0, 0, 0, 1],
      fingers: [3, 2, 0, 0, 0, 1],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'G_maj7': ChordVoicing(
      frets: [3, 2, 0, 0, 0, 2],
      fingers: [3, 2, 0, 0, 0, 1],
      stringNames: ChordVoicing.guitarStrings,
    ),
    // A family
    'A_': ChordVoicing(
      frets: [-1, 0, 2, 2, 2, 0],
      fingers: [0, 0, 1, 2, 3, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'A_m': ChordVoicing(
      frets: [-1, 0, 2, 2, 1, 0],
      fingers: [0, 0, 2, 3, 1, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'A_7': ChordVoicing(
      frets: [-1, 0, 2, 0, 2, 0],
      fingers: [0, 0, 2, 0, 3, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'A_maj7': ChordVoicing(
      frets: [-1, 0, 2, 1, 2, 0],
      fingers: [0, 0, 2, 1, 3, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'A_m7': ChordVoicing(
      frets: [-1, 0, 2, 0, 1, 0],
      fingers: [0, 0, 2, 0, 1, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'A_sus2': ChordVoicing(
      frets: [-1, 0, 2, 2, 0, 0],
      fingers: [0, 0, 1, 2, 0, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'A_sus4': ChordVoicing(
      frets: [-1, 0, 2, 2, 3, 0],
      fingers: [0, 0, 1, 2, 3, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
    // B family
    'B_7': ChordVoicing(
      frets: [-1, 2, 1, 2, 0, 2],
      fingers: [0, 2, 1, 3, 0, 4],
      stringNames: ChordVoicing.guitarStrings,
    ),
    'B_dim': ChordVoicing(
      frets: [-1, 2, 3, 4, 3, -1],
      fingers: [0, 1, 2, 4, 3, 0],
      stringNames: ChordVoicing.guitarStrings,
    ),
  };

  static const Map<String, ChordVoicing> _ukuleleVoicings = {
    'C_': ChordVoicing(
      frets: [0, 0, 0, 3],
      fingers: [0, 0, 0, 3],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'C_m': ChordVoicing(
      frets: [0, 3, 3, 3],
      fingers: [0, 1, 2, 3],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'C_7': ChordVoicing(
      frets: [0, 0, 0, 1],
      fingers: [0, 0, 0, 1],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'C_maj7': ChordVoicing(
      frets: [0, 0, 0, 2],
      fingers: [0, 0, 0, 2],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'D_': ChordVoicing(
      frets: [2, 2, 2, 0],
      fingers: [1, 2, 3, 0],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'D_m': ChordVoicing(
      frets: [2, 2, 1, 0],
      fingers: [2, 3, 1, 0],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'D_7': ChordVoicing(
      frets: [2, 2, 2, 3],
      fingers: [1, 1, 1, 2],
      barres: [ChordBarre(fret: 2, startString: 0, endString: 2)],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'E_': ChordVoicing(
      frets: [4, 4, 4, 2],
      fingers: [2, 3, 4, 1],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'E_m': ChordVoicing(
      frets: [0, 4, 3, 2],
      fingers: [0, 3, 2, 1],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'E_7': ChordVoicing(
      frets: [1, 2, 0, 2],
      fingers: [1, 2, 0, 3],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'F_': ChordVoicing(
      frets: [2, 0, 1, 0],
      fingers: [2, 0, 1, 0],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'F_m': ChordVoicing(
      frets: [1, 0, 1, 3],
      fingers: [1, 0, 2, 4],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'F_7': ChordVoicing(
      frets: [2, 3, 1, 0],
      fingers: [2, 3, 1, 0],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'G_': ChordVoicing(
      frets: [0, 2, 3, 2],
      fingers: [0, 1, 3, 2],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'G_m': ChordVoicing(
      frets: [0, 2, 3, 1],
      fingers: [0, 2, 3, 1],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'G_7': ChordVoicing(
      frets: [0, 2, 1, 2],
      fingers: [0, 2, 1, 3],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'A_': ChordVoicing(
      frets: [2, 1, 0, 0],
      fingers: [2, 1, 0, 0],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'A_m': ChordVoicing(
      frets: [2, 0, 0, 0],
      fingers: [2, 0, 0, 0],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'A_7': ChordVoicing(
      frets: [0, 1, 0, 0],
      fingers: [0, 1, 0, 0],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'B_': ChordVoicing(
      frets: [4, 3, 2, 2],
      fingers: [3, 2, 1, 1],
      barres: [ChordBarre(fret: 2, startString: 2, endString: 3)],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'B_m': ChordVoicing(
      frets: [4, 2, 2, 2],
      fingers: [3, 1, 1, 1],
      barres: [ChordBarre(fret: 2, startString: 1, endString: 3)],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
    'B_dim': ChordVoicing(
      frets: [1, 2, 1, 2],
      fingers: [1, 3, 2, 4],
      stringNames: ChordVoicing.ukuleleStrings,
    ),
  };
}
