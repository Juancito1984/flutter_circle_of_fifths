import 'chord_model.dart';

/// Musical genre or context for harmonic progressions.
enum ProgressionGenre {
  /// Pop and Rock progressions (e.g. I - V - vi - IV).
  popRock,

  /// Jazz and Bossa Nova cadences (e.g. ii - V - I).
  jazz,

  /// 12-bar and traditional Blues.
  blues,

  /// Classical, Baroque, and Folk (e.g. Canon in D).
  classical,

  /// Custom user-crafted progression.
  custom,
}

/// Represents a single harmonic chord step within a progression.
class ProgressionStep {
  /// Roman numeral degree symbol (e.g., `"I"`, `"V"`, `"vi"`, `"ii7"`, `"V7/V"`).
  final String romanNumeral;

  /// Semitone distance from the tonic root note (0..11).
  final int semitoneOffset;

  /// Chord quality suffix (e.g., `""`, `"m"`, `"7"`, `"maj7"`, `"dim"`).
  final String quality;

  /// Harmonic function label (e.g., `"Tonic"`, `"Dominant"`, `"Subdominant"`, `"Secondary Dominant"`).
  final String functionName;

  /// Creates a [ProgressionStep].
  const ProgressionStep({
    required this.romanNumeral,
    required this.semitoneOffset,
    required this.quality,
    required this.functionName,
  });
}

/// Represents a reusable or custom harmonic chord progression template.
class HarmonicProgression {
  /// Name of the progression (e.g., `"4-Chord Pop Wonder"`, `"Jazz ii - V - I"`).
  final String name;

  /// Musical genre or style.
  final ProgressionGenre genre;

  /// Description and famous songs using this progression.
  final String description;

  /// Ordered list of harmonic steps.
  final List<ProgressionStep> steps;

  /// Creates a [HarmonicProgression].
  const HarmonicProgression({
    required this.name,
    required this.genre,
    required this.description,
    required this.steps,
  });

  /// Resolves the concrete chord symbols for this progression in the given [key]
  /// (e.g., `['C', 'G', 'Am', 'F']` in key of C).
  List<String> getChordsForKey(String key, {bool? preferFlats}) {
    final rootIndex = ChordTransposer.noteToSemitone(key);
    if (rootIndex == -1) return const [];
    final useFlats = preferFlats ?? ChordTransposer.prefersFlatsForKey(key);

    return steps.map((step) {
      final chordRootIndex = (rootIndex + step.semitoneOffset) % 12;
      final chordRoot = ChordTransposer.semitoneToNote(
        chordRootIndex,
        preferFlats: useFlats,
      );
      return '$chordRoot${step.quality}';
    }).toList();
  }

  /// Popular pre-configured harmonic progression templates.
  static const List<HarmonicProgression> standardTemplates = [
    HarmonicProgression(
      name: 'I - V - vi - IV (Axis of Awesome)',
      genre: ProgressionGenre.popRock,
      description:
          'The most successful chord progression in modern music history. Used in hundreds of hits including "Don\'t Stop Believin\'", "Let It Be", "With or Without You", and "Someone Like You".',
      steps: [
        ProgressionStep(
          romanNumeral: 'I',
          semitoneOffset: 0,
          quality: '',
          functionName: 'Tonic',
        ),
        ProgressionStep(
          romanNumeral: 'V',
          semitoneOffset: 7,
          quality: '',
          functionName: 'Dominant',
        ),
        ProgressionStep(
          romanNumeral: 'vi',
          semitoneOffset: 9,
          quality: 'm',
          functionName: 'Submediant',
        ),
        ProgressionStep(
          romanNumeral: 'IV',
          semitoneOffset: 5,
          quality: '',
          functionName: 'Subdominant',
        ),
      ],
    ),
    HarmonicProgression(
      name: 'ii - V - I (Jazz Cadence)',
      genre: ProgressionGenre.jazz,
      description:
          'The backbone of Jazz harmony and Broadway standards. Creates smooth voice leading with strong dominant resolution to the tonic.',
      steps: [
        ProgressionStep(
          romanNumeral: 'ii7',
          semitoneOffset: 2,
          quality: 'm7',
          functionName: 'Supertonic',
        ),
        ProgressionStep(
          romanNumeral: 'V7',
          semitoneOffset: 7,
          quality: '7',
          functionName: 'Dominant',
        ),
        ProgressionStep(
          romanNumeral: 'Imaj7',
          semitoneOffset: 0,
          quality: 'maj7',
          functionName: 'Tonic',
        ),
      ],
    ),
    HarmonicProgression(
      name: 'I - vi - IV - V (50s Doo-Wop)',
      genre: ProgressionGenre.popRock,
      description:
          'The defining sound of 1950s rock and roll and doo-wop ballads. Classic examples: "Stand by Me", "Earth Angel", "Every Breath You Take".',
      steps: [
        ProgressionStep(
          romanNumeral: 'I',
          semitoneOffset: 0,
          quality: '',
          functionName: 'Tonic',
        ),
        ProgressionStep(
          romanNumeral: 'vi',
          semitoneOffset: 9,
          quality: 'm',
          functionName: 'Submediant',
        ),
        ProgressionStep(
          romanNumeral: 'IV',
          semitoneOffset: 5,
          quality: '',
          functionName: 'Subdominant',
        ),
        ProgressionStep(
          romanNumeral: 'V',
          semitoneOffset: 7,
          quality: '',
          functionName: 'Dominant',
        ),
      ],
    ),
    HarmonicProgression(
      name: 'Pachelbel Canon',
      genre: ProgressionGenre.classical,
      description:
          'Johann Pachelbel\'s timeless sequence (I - V - vi - iii - IV - I - IV - V). Adapted in pop songs like "Memories" by Maroon 5 and "Basket Case" by Green Day.',
      steps: [
        ProgressionStep(
          romanNumeral: 'I',
          semitoneOffset: 0,
          quality: '',
          functionName: 'Tonic',
        ),
        ProgressionStep(
          romanNumeral: 'V',
          semitoneOffset: 7,
          quality: '',
          functionName: 'Dominant',
        ),
        ProgressionStep(
          romanNumeral: 'vi',
          semitoneOffset: 9,
          quality: 'm',
          functionName: 'Submediant',
        ),
        ProgressionStep(
          romanNumeral: 'iii',
          semitoneOffset: 4,
          quality: 'm',
          functionName: 'Mediant',
        ),
        ProgressionStep(
          romanNumeral: 'IV',
          semitoneOffset: 5,
          quality: '',
          functionName: 'Subdominant',
        ),
        ProgressionStep(
          romanNumeral: 'I',
          semitoneOffset: 0,
          quality: '',
          functionName: 'Tonic',
        ),
        ProgressionStep(
          romanNumeral: 'IV',
          semitoneOffset: 5,
          quality: '',
          functionName: 'Subdominant',
        ),
        ProgressionStep(
          romanNumeral: 'V',
          semitoneOffset: 7,
          quality: '',
          functionName: 'Dominant',
        ),
      ],
    ),
    HarmonicProgression(
      name: '12-Bar Blues',
      genre: ProgressionGenre.blues,
      description:
          'The foundational 12-bar blues form (I7 - IV7 - I7 - V7 - IV7 - I7). Root of Rock and Roll, R&B and Funk.',
      steps: [
        ProgressionStep(
          romanNumeral: 'I7',
          semitoneOffset: 0,
          quality: '7',
          functionName: 'Tonic Dominant',
        ),
        ProgressionStep(
          romanNumeral: 'IV7',
          semitoneOffset: 5,
          quality: '7',
          functionName: 'Subdominant',
        ),
        ProgressionStep(
          romanNumeral: 'I7',
          semitoneOffset: 0,
          quality: '7',
          functionName: 'Tonic Dominant',
        ),
        ProgressionStep(
          romanNumeral: 'V7',
          semitoneOffset: 7,
          quality: '7',
          functionName: 'Dominant Turnaround',
        ),
      ],
    ),
    HarmonicProgression(
      name: 'Andalusian Cadence (vi - V - IV - III)',
      genre: ProgressionGenre.classical,
      description:
          'Traditional descending minor tetrachord cadence used in Flamenco, Classical, and Rock (e.g. "Hit the Road Jack", "Stairway to Heaven", "Sultans of Swing").',
      steps: [
        ProgressionStep(
          romanNumeral: 'i',
          semitoneOffset: 0,
          quality: 'm',
          functionName: 'Minor Tonic',
        ),
        ProgressionStep(
          romanNumeral: 'bVII',
          semitoneOffset: 10,
          quality: '',
          functionName: 'Subtonic',
        ),
        ProgressionStep(
          romanNumeral: 'bVI',
          semitoneOffset: 8,
          quality: '',
          functionName: 'Submediant',
        ),
        ProgressionStep(
          romanNumeral: 'V',
          semitoneOffset: 7,
          quality: '',
          functionName: 'Major Dominant',
        ),
      ],
    ),
  ];

  /// Suggests secondary dominant or modulation chords for [key].
  static List<ProgressionStep> getPassingChordSuggestions(String key) {
    return const [
      ProgressionStep(
        romanNumeral: 'V7/V',
        semitoneOffset: 2,
        quality: '7',
        functionName: 'Secondary Dominant to V (Prepares the Dominant)',
      ),
      ProgressionStep(
        romanNumeral: 'V7/ii',
        semitoneOffset: 9,
        quality: '7',
        functionName: 'Secondary Dominant to ii (Tonicizes Supertonic)',
      ),
      ProgressionStep(
        romanNumeral: 'V7/vi',
        semitoneOffset: 4,
        quality: '7',
        functionName: 'Secondary Dominant to Relative Minor',
      ),
      ProgressionStep(
        romanNumeral: 'bVII',
        semitoneOffset: 10,
        quality: '',
        functionName: 'Modal Borrowing (Mixolydian Subtonic)',
      ),
      ProgressionStep(
        romanNumeral: 'iv',
        semitoneOffset: 5,
        quality: 'm',
        functionName: 'Borrowed Minor Subdominant (Romantic/Film cadence)',
      ),
    ];
  }

  /// Calculates Roman numeral analysis for any chord in relation to [key].
  static String analyzeChordRoman(String chordSymbol, String key) {
    final keyRoot = ChordTransposer.noteToSemitone(key);
    final chordInfo = ChordTransposer.parseChord(chordSymbol);
    final chordRoot = ChordTransposer.noteToSemitone(chordInfo.root);
    if (keyRoot == -1 || chordRoot == -1) return chordSymbol;

    final diff = ((chordRoot - keyRoot) % 12 + 12) % 12;
    final isMinor = chordInfo.quality.startsWith('m') && !chordInfo.quality.startsWith('maj');
    final isDim = chordInfo.quality.contains('dim') || chordInfo.quality.contains('°');

    String roman;
    switch (diff) {
      case 0:
        roman = isMinor ? 'i' : 'I';
        break;
      case 1:
        roman = isMinor ? 'bii' : 'bII';
        break;
      case 2:
        roman = isMinor ? 'ii' : 'II';
        break;
      case 3:
        roman = isMinor ? 'biii' : 'bIII';
        break;
      case 4:
        roman = isMinor ? 'iii' : 'III';
        break;
      case 5:
        roman = isMinor ? 'iv' : 'IV';
        break;
      case 6:
        roman = isDim ? 'bvo' : '#IV';
        break;
      case 7:
        roman = isMinor ? 'v' : 'V';
        break;
      case 8:
        roman = isMinor ? 'bvi' : 'bVI';
        break;
      case 9:
        roman = isMinor ? 'vi' : 'VI';
        break;
      case 10:
        roman = isMinor ? 'bvii' : 'bVII';
        break;
      case 11:
        roman = isDim ? 'viio' : (isMinor ? 'vii' : 'VII');
        break;
      default:
        roman = 'I';
    }

    if (chordInfo.quality.contains('7') && !chordInfo.quality.contains('maj')) {
      return '$roman${isDim ? 'o7' : '7'}';
    } else if (chordInfo.quality.contains('maj7')) {
      return '${roman}maj7';
    }
    return roman;
  }
}
