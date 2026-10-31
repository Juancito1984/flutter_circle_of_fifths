/// Represents a position within the Circle of Fifths with its harmonic relationships,
/// key signature, and diatonic scale notes for both Major and Relative Minor modes.
class CircleOfFifthsModel {
  /// Major key note (Degree I)
  final String major;

  /// Relative minor key note (Degree vi)
  final String minor;

  /// Subdominant key (Degree IV)
  final String subdominant;

  /// Dominant key (Degree V)
  final String dominant;

  /// Key signature notation (e.g., "0#", "1#", "2b")
  final String keySignature;

  /// Secondary degrees (ii, iii)
  final List<String> secondaryChords;

  /// Complete 8-note Major scale
  final List<String> majorScaleNotes;

  /// Complete 8-note Natural Minor scale
  final List<String> minorScaleNotes;

  const CircleOfFifthsModel({
    required this.major,
    required this.minor,
    required this.subdominant,
    required this.dominant,
    required this.keySignature,
    required this.secondaryChords,
    required this.majorScaleNotes,
    required this.minorScaleNotes,
  });

  /// Static collection of all 12 key positions in Circle of Fifths order.
  static const List<CircleOfFifthsModel> defaultKeys = [
    CircleOfFifthsModel(
      major: 'C',
      minor: 'a',
      subdominant: 'F',
      dominant: 'G',
      keySignature: '0#',
      secondaryChords: ['Dm', 'Em'],
      majorScaleNotes: ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C'],
      minorScaleNotes: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'A'],
    ),
    CircleOfFifthsModel(
      major: 'G',
      minor: 'e',
      subdominant: 'C',
      dominant: 'D',
      keySignature: '1#',
      secondaryChords: ['Am', 'Bm'],
      majorScaleNotes: ['G', 'A', 'B', 'C', 'D', 'E', 'F#', 'G'],
      minorScaleNotes: ['E', 'F#', 'G', 'A', 'B', 'C', 'D', 'E'],
    ),
    CircleOfFifthsModel(
      major: 'D',
      minor: 'b',
      subdominant: 'G',
      dominant: 'A',
      keySignature: '2#',
      secondaryChords: ['Em', 'F#m'],
      majorScaleNotes: ['D', 'E', 'F#', 'G', 'A', 'B', 'C#', 'D'],
      minorScaleNotes: ['B', 'C#', 'D', 'E', 'F#', 'G', 'A', 'B'],
    ),
    CircleOfFifthsModel(
      major: 'A',
      minor: 'f#',
      subdominant: 'D',
      dominant: 'E',
      keySignature: '3#',
      secondaryChords: ['Bm', 'C#m'],
      majorScaleNotes: ['A', 'B', 'C#', 'D', 'E', 'F#', 'G#', 'A'],
      minorScaleNotes: ['F#', 'G#', 'A', 'B', 'C#', 'D', 'E', 'F#'],
    ),
    CircleOfFifthsModel(
      major: 'E',
      minor: 'c#',
      subdominant: 'A',
      dominant: 'B',
      keySignature: '4#',
      secondaryChords: ['F#m', 'G#m'],
      majorScaleNotes: ['E', 'F#', 'G#', 'A', 'B', 'C#', 'D#', 'E'],
      minorScaleNotes: ['C#', 'D#', 'E', 'F#', 'G#', 'A', 'B', 'C#'],
    ),
    CircleOfFifthsModel(
      major: 'B',
      minor: 'g#',
      subdominant: 'E',
      dominant: 'F#',
      keySignature: '5#',
      secondaryChords: ['C#m', 'D#m'],
      majorScaleNotes: ['B', 'C#', 'D#', 'E', 'F#', 'G#', 'A#', 'B'],
      minorScaleNotes: ['G#', 'A#', 'B', 'C#', 'D#', 'E', 'F#', 'G#'],
    ),
    CircleOfFifthsModel(
      major: 'F#',
      minor: 'd#',
      subdominant: 'B',
      dominant: 'C#',
      keySignature: '6#',
      secondaryChords: ['G#m', 'A#m'],
      majorScaleNotes: ['F#', 'G#', 'A#', 'B', 'C#', 'D#', 'E#', 'F#'],
      minorScaleNotes: ['D#', 'E#', 'F#', 'G#', 'A#', 'B', 'C#', 'D#'],
    ),
    CircleOfFifthsModel(
      major: 'Db',
      minor: 'a#',
      subdominant: 'Gb',
      dominant: 'Ab',
      keySignature: '5b',
      secondaryChords: ['Ebm', 'Fm'],
      majorScaleNotes: ['Db', 'Eb', 'F', 'Gb', 'Ab', 'Bb', 'C', 'Db'],
      minorScaleNotes: ['Bb', 'C', 'Db', 'Eb', 'F', 'Gb', 'Ab', 'Bb'],
    ),
    CircleOfFifthsModel(
      major: 'Ab',
      minor: 'f',
      subdominant: 'Db',
      dominant: 'Eb',
      keySignature: '4b',
      secondaryChords: ['Bbm', 'Cm'],
      majorScaleNotes: ['Ab', 'Bb', 'C', 'Db', 'Eb', 'F', 'G', 'Ab'],
      minorScaleNotes: ['F', 'G', 'Ab', 'Bb', 'C', 'Db', 'Eb', 'F'],
    ),
    CircleOfFifthsModel(
      major: 'Eb',
      minor: 'c',
      subdominant: 'Ab',
      dominant: 'Bb',
      keySignature: '3b',
      secondaryChords: ['Fm', 'Gm'],
      majorScaleNotes: ['Eb', 'F', 'G', 'Ab', 'Bb', 'C', 'D', 'Eb'],
      minorScaleNotes: ['C', 'D', 'Eb', 'F', 'G', 'Ab', 'Bb', 'C'],
    ),
    CircleOfFifthsModel(
      major: 'Bb',
      minor: 'g',
      subdominant: 'Eb',
      dominant: 'F',
      keySignature: '2b',
      secondaryChords: ['Cm', 'Dm'],
      majorScaleNotes: ['Bb', 'C', 'D', 'Eb', 'F', 'G', 'A', 'Bb'],
      minorScaleNotes: ['G', 'A', 'Bb', 'C', 'D', 'Eb', 'F', 'G'],
    ),
    CircleOfFifthsModel(
      major: 'F',
      minor: 'd',
      subdominant: 'Bb',
      dominant: 'C',
      keySignature: '1b',
      secondaryChords: ['Gm', 'Am'],
      majorScaleNotes: ['F', 'G', 'A', 'Bb', 'C', 'D', 'E', 'F'],
      minorScaleNotes: ['D', 'E', 'F', 'G', 'A', 'Bb', 'C', 'D'],
    ),
  ];
}
