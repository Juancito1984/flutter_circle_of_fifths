import 'chord_model.dart';

/// Represents a paired chord and lyric fragment within a song line.
class ChordLyricSegment {
  /// Optional chord symbol positioned above [lyric] (e.g., `"C"`, `"G7"`).
  final String? chord;

  /// Lyric text fragment positioned below [chord].
  final String lyric;

  /// Creates a [ChordLyricSegment] pair.
  const ChordLyricSegment({
    this.chord,
    required this.lyric,
  });
}

/// Classification of a line inside a [ChordSheetDocument].
enum ChordSheetLineType {
  /// Song title directive (e.g., `{title: Amazing Grace}`).
  title,

  /// Song artist/subtitle directive (e.g., `{subtitle: John Newton}`).
  subtitle,

  /// Section label such as `[Verse 1]`, `[Chorus]`, or `{comment: Bridge}`.
  section,

  /// Line containing lyrics and/or inline bracketed chords.
  chordLyrics,

  /// Empty spacing line.
  empty,
}

/// Represents a single parsed line in a ChordPro / bracket-notation song sheet.
class ChordSheetLine {
  /// Semantic type of this line.
  final ChordSheetLineType type;

  /// Segments of chords and lyrics when [type] is [ChordSheetLineType.chordLyrics].
  final List<ChordLyricSegment> segments;

  /// Header or section text when [type] is title, subtitle, or section.
  final String? headerText;

  /// Creates a [ChordSheetLine].
  const ChordSheetLine({
    required this.type,
    this.segments = const [],
    this.headerText,
  });
}

/// Parsed representation of a song in Bracket / ChordPro notation.
class ChordSheetDocument {
  /// Optional song title parsed from `{title: ...}` or `{t: ...}`.
  final String? title;

  /// Optional subtitle/artist parsed from `{subtitle: ...}`, `{st: ...}`, or `{artist: ...}`.
  final String? subtitle;

  /// Optional musical key parsed from `{key: ...}`.
  final String? key;

  /// Ordered list of parsed song lines.
  final List<ChordSheetLine> lines;

  /// Distinct list of chord symbols appearing in the document (after transposition).
  final List<String> uniqueChords;

  /// Creates a [ChordSheetDocument].
  const ChordSheetDocument({
    this.title,
    this.subtitle,
    this.key,
    required this.lines,
    required this.uniqueChords,
  });

  /// Parses raw ChordPro / bracketed song text into a [ChordSheetDocument],
  /// optionally transposing all chords by [transposeSemitones] and adapting
  /// accidentals to [targetKey] or [preferFlats].
  factory ChordSheetDocument.parse(
    String rawText, {
    int transposeSemitones = 0,
    bool? preferFlats,
    String? targetKey,
  }) {
    String? title;
    String? subtitle;
    String? key;
    final lines = <ChordSheetLine>[];
    final uniqueChordsSet = <String>{};

    final rawLines = rawText.replaceAll('\r\n', '\n').split('\n');

    for (final rawLine in rawLines) {
      final trimmed = rawLine.trim();
      if (trimmed.isEmpty) {
        lines.add(const ChordSheetLine(type: ChordSheetLineType.empty));
        continue;
      }

      // Check ChordPro directives: {title: ...}, {subtitle: ...}, {key: ...}, {comment: ...}
      final directiveMatch =
          RegExp(r'^\{([a-zA-Z_]+)\s*:\s*(.+)\}$').firstMatch(trimmed);
      if (directiveMatch != null) {
        final tag = directiveMatch.group(1)!.toLowerCase();
        final value = directiveMatch.group(2)!.trim();
        if (tag == 'title' || tag == 't') {
          title = value;
          lines.add(
            ChordSheetLine(type: ChordSheetLineType.title, headerText: value),
          );
          continue;
        } else if (tag == 'subtitle' || tag == 'st' || tag == 'artist') {
          subtitle = value;
          lines.add(
            ChordSheetLine(
              type: ChordSheetLineType.subtitle,
              headerText: value,
            ),
          );
          continue;
        } else if (tag == 'key' || tag == 'k') {
          key = ChordTransposer.transposeChord(
            value,
            transposeSemitones,
            preferFlats: preferFlats,
            targetKey: targetKey,
          );
          continue;
        } else if (tag == 'comment' ||
            tag == 'c' ||
            tag == 'chorus' ||
            tag == 'verse') {
          lines.add(
            ChordSheetLine(type: ChordSheetLineType.section, headerText: value),
          );
          continue;
        }
      }

      // Check standalone section header like [Chorus] or [Verse 1]
      final sectionOnlyMatch =
          RegExp(r'^\[([^\[\]]+)\]$').firstMatch(trimmed);
      if (sectionOnlyMatch != null) {
        final inside = sectionOnlyMatch.group(1)!.trim();
        if (!ChordTransposer.isChordSymbol(inside)) {
          lines.add(
            ChordSheetLine(
              type: ChordSheetLineType.section,
              headerText: inside,
            ),
          );
          continue;
        }
      }

      // Parse inline [Chord]Lyric segments
      final segments = _parseChordLyricLine(
        rawLine,
        transposeSemitones: transposeSemitones,
        preferFlats: preferFlats,
        targetKey: targetKey ?? key,
        uniqueChordsSet: uniqueChordsSet,
      );

      lines.add(
        ChordSheetLine(
          type: ChordSheetLineType.chordLyrics,
          segments: segments,
        ),
      );
    }

    return ChordSheetDocument(
      title: title,
      subtitle: subtitle,
      key: targetKey ?? key,
      lines: lines,
      uniqueChords: uniqueChordsSet.toList(growable: false),
    );
  }

  static List<ChordLyricSegment> _parseChordLyricLine(
    String line, {
    required int transposeSemitones,
    required bool? preferFlats,
    required String? targetKey,
    required Set<String> uniqueChordsSet,
  }) {
    final segments = <ChordLyricSegment>[];
    final bracketRegex = RegExp(r'\[([^\[\]]+)\]');
    final matches = bracketRegex.allMatches(line).toList();

    if (matches.isEmpty) {
      return [ChordLyricSegment(lyric: line)];
    }

    // Text before the first bracket
    if (matches.first.start > 0) {
      final leadingText = line.substring(0, matches.first.start);
      if (leadingText.isNotEmpty) {
        segments.add(ChordLyricSegment(lyric: leadingText));
      }
    }

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final rawToken = match.group(1)!.trim();
      final nextStart =
          (i + 1 < matches.length) ? matches[i + 1].start : line.length;
      final followingLyric = line.substring(match.end, nextStart);

      if (ChordTransposer.isChordSymbol(rawToken)) {
        final transposedChord = ChordTransposer.transposeChord(
          rawToken,
          transposeSemitones,
          preferFlats: preferFlats,
          targetKey: targetKey,
        );
        uniqueChordsSet.add(transposedChord);

        // Split lyric into word chunks so long phrases wrap naturally in Flutter Wrap
        _appendWordSegments(
          segments,
          chord: transposedChord,
          lyric: followingLyric,
        );
      } else {
        segments.add(
          ChordLyricSegment(
            lyric: '[${match.group(1)}]$followingLyric',
          ),
        );
      }
    }

    return segments;
  }

  static void _appendWordSegments(
    List<ChordLyricSegment> target, {
    required String chord,
    required String lyric,
  }) {
    if (lyric.isEmpty) {
      target.add(ChordLyricSegment(chord: chord, lyric: ''));
      return;
    }

    // Keep first word (and trailing space) attached to the chord, and split remaining words
    // so that long lines wrap gracefully on narrow screens without breaking chord alignment.
    final wordMatches = RegExp(r'\S+\s*|\s+').allMatches(lyric).toList();
    if (wordMatches.isEmpty) {
      target.add(ChordLyricSegment(chord: chord, lyric: lyric));
      return;
    }

    target.add(
      ChordLyricSegment(
        chord: chord,
        lyric: wordMatches.first.group(0)!,
      ),
    );

    for (int i = 1; i < wordMatches.length; i++) {
      target.add(
        ChordLyricSegment(
          lyric: wordMatches[i].group(0)!,
        ),
      );
    }
  }
}
