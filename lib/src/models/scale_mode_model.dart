import 'chord_model.dart';

/// Categories of musical scales supported by the library.
enum ScaleCategory {
  /// Seven church/Gregorian modes derived from the major scale.
  diatonicMode,

  /// Pentatonic and blues scales commonly used in popular and contemporary music.
  pentatonicAndBlues,

  /// Harmonic and melodic minor scales with modified 6th or 7th degrees.
  minorVariants,

  /// Symmetric and world scales (whole tone, diminished).
  symmetricAndExotic,
}

/// Definition of a musical scale formula with interval steps and descriptions.
class ScaleFormula {
  /// Name of the scale or mode (e.g., `"Dorian"`, `"Major Pentatonic"`).
  final String name;

  /// High-level scale category.
  final ScaleCategory category;

  /// Semitone offsets from the root note (e.g., `[0, 2, 4, 5, 7, 9, 11]` for Ionian/Major).
  final List<int> semitoneOffsets;

  /// Degree names/interval labels (e.g., `['1', '2', 'b3', '4', '5', '6', 'b7']`).
  final List<String> degreeLabels;

  /// Step distance pattern between adjacent notes in semitones (e.g., `[2, 1, 2, 2, 2, 1, 2]`).
  final List<int> steps;

  /// Educational description of the mode's sonic character and mood.
  final String description;

  /// Creates a [ScaleFormula] defining intervals, steps, and degrees.
  const ScaleFormula({
    required this.name,
    required this.category,
    required this.semitoneOffsets,
    required this.degreeLabels,
    required this.steps,
    required this.description,
  });

  /// The standard 7 Gregorian Modes:
  /// Ionian (Major), Dorian, Phrygian, Lydian, Mixolydian, Aeolian (Natural Minor), Locrian.
  static const List<ScaleFormula> gregorianModes = [
    ScaleFormula(
      name: 'Ionian (Major)',
      category: ScaleCategory.diatonicMode,
      semitoneOffsets: [0, 2, 4, 5, 7, 9, 11],
      degreeLabels: ['1', '2', '3', '4', '5', '6', '7'],
      steps: [2, 2, 1, 2, 2, 2, 1],
      description: 'The foundation of Western music. Bright, stable, joyful and heroic.',
    ),
    ScaleFormula(
      name: 'Dorian',
      category: ScaleCategory.diatonicMode,
      semitoneOffsets: [0, 2, 3, 5, 7, 9, 10],
      degreeLabels: ['1', '2', 'b3', '4', '5', '6', 'b7'],
      steps: [2, 1, 2, 2, 2, 1, 2],
      description: 'Minor mode with a raised natural 6th. Jazzy, medieval, bittersweet (e.g. "Scarborough Fair", "Oye Como Va").',
    ),
    ScaleFormula(
      name: 'Phrygian',
      category: ScaleCategory.diatonicMode,
      semitoneOffsets: [0, 1, 3, 5, 7, 8, 10],
      degreeLabels: ['1', 'b2', 'b3', '4', '5', 'b6', 'b7'],
      steps: [1, 2, 2, 2, 1, 2, 2],
      description: 'Minor mode with a dark minor 2nd. Spanish flamenco flavor, tense and exotic.',
    ),
    ScaleFormula(
      name: 'Lydian',
      category: ScaleCategory.diatonicMode,
      semitoneOffsets: [0, 2, 4, 6, 7, 9, 11],
      degreeLabels: ['1', '2', '3', '#4', '5', '6', '7'],
      steps: [2, 2, 2, 1, 2, 2, 1],
      description: 'Major mode with a raised #4th. Dreamy, magical, celestial and film-score like (e.g. "The Simpsons", "E.T.").',
    ),
    ScaleFormula(
      name: 'Mixolydian',
      category: ScaleCategory.diatonicMode,
      semitoneOffsets: [0, 2, 4, 5, 7, 9, 10],
      degreeLabels: ['1', '2', '3', '4', '5', '6', 'b7'],
      steps: [2, 2, 1, 2, 2, 1, 2],
      description: 'Major mode with a flattened dominant 7th. Essential in Blues, Rock and Celtic music (e.g. "Sweet Home Alabama", "Norwegian Wood").',
    ),
    ScaleFormula(
      name: 'Aeolian (Natural Minor)',
      category: ScaleCategory.diatonicMode,
      semitoneOffsets: [0, 2, 3, 5, 7, 8, 10],
      degreeLabels: ['1', '2', 'b3', '4', '5', 'b6', 'b7'],
      steps: [2, 1, 2, 2, 1, 2, 2],
      description: 'The natural minor scale. Melancholic, emotional, epic and reflective.',
    ),
    ScaleFormula(
      name: 'Locrian',
      category: ScaleCategory.diatonicMode,
      semitoneOffsets: [0, 1, 3, 5, 6, 8, 10],
      degreeLabels: ['1', 'b2', 'b3', '4', 'b5', 'b6', 'b7'],
      steps: [1, 2, 2, 1, 2, 2, 2],
      description: 'Unstable diminished mode with a tritone b5. Tense, ominous and unresolved. Used in Metal and modern Jazz.',
    ),
  ];

  /// Popular pentatonic, blues, and advanced minor scales.
  static const List<ScaleFormula> advancedScales = [
    ScaleFormula(
      name: 'Major Pentatonic',
      category: ScaleCategory.pentatonicAndBlues,
      semitoneOffsets: [0, 2, 4, 7, 9],
      degreeLabels: ['1', '2', '3', '5', '6'],
      steps: [2, 2, 3, 2, 3],
      description: '5-note scale without half steps. Melodic, uplifting, fundamental in Pop, Country and Folk.',
    ),
    ScaleFormula(
      name: 'Minor Pentatonic',
      category: ScaleCategory.pentatonicAndBlues,
      semitoneOffsets: [0, 3, 5, 7, 10],
      degreeLabels: ['1', 'b3', '4', '5', 'b7'],
      steps: [3, 2, 2, 3, 2],
      description: 'The most popular guitar soloing scale. Raw, powerful, bluesy and versatile.',
    ),
    ScaleFormula(
      name: 'Blues Scale',
      category: ScaleCategory.pentatonicAndBlues,
      semitoneOffsets: [0, 3, 5, 6, 7, 10],
      degreeLabels: ['1', 'b3', '4', 'b5', '5', 'b7'],
      steps: [3, 2, 1, 1, 3, 2],
      description: 'Minor pentatonic enriched with the iconic "blue note" (diminished 5th). Expressive and soulful.',
    ),
    ScaleFormula(
      name: 'Harmonic Minor',
      category: ScaleCategory.minorVariants,
      semitoneOffsets: [0, 2, 3, 5, 7, 8, 11],
      degreeLabels: ['1', '2', 'b3', '4', '5', 'b6', '7'],
      steps: [2, 1, 2, 2, 1, 3, 1],
      description: 'Minor scale with a raised natural 7th leading tone. Dramatic, neo-classical and Middle Eastern flavor.',
    ),
    ScaleFormula(
      name: 'Melodic Minor (Jazz Minor)',
      category: ScaleCategory.minorVariants,
      semitoneOffsets: [0, 2, 3, 5, 7, 9, 11],
      degreeLabels: ['1', '2', 'b3', '4', '5', '6', '7'],
      steps: [2, 1, 2, 2, 2, 2, 1],
      description: 'Minor scale with raised 6th and 7th. Sophisticated, modern jazz staple that gives rise to Altered and Lydian Dominant modes.',
    ),
  ];

  /// All supported scale formulas combined.
  static const List<ScaleFormula> allScales = [
    ...gregorianModes,
    ...advancedScales,
  ];

  /// Builds the concrete note list for this scale when rooted at [rootNote].
  List<String> getNotes(String rootNote, {bool? preferFlats}) {
    final rootIndex = ChordTransposer.noteToSemitone(rootNote);
    if (rootIndex == -1) return const [];
    final useFlats = preferFlats ??
        (rootNote.contains('b') ||
            rootNote.contains('♭') ||
            rootIndex == 5 ||
            rootIndex == 10);

    return semitoneOffsets.map((offset) {
      final semitone = (rootIndex + offset) % 12;
      return ChordTransposer.semitoneToNote(semitone, preferFlats: useFlats);
    }).toList();
  }
}
