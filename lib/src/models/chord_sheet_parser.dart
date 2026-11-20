import 'chord_model.dart';

/// Represents a paired chord and lyric fragment within a song line.
class ChordLyricSegment {
  /// Optional chord symbol positioned above [lyric] (e.g., `"C"`, `"G7"`, `"D/F#m"`).
  final String? chord;

  /// Individual chord symbols positioned above [lyric].
  ///
  /// For a single chord (e.g., `"C"` or `"D/F#"`), contains one item.
  /// For compound chords (e.g., `[D][/][F#m]` or `[D/F#m]`), contains each
  /// chord individually (e.g., `["D", "F#m"]`) so each one can be tapped and
  /// transposed independently.
  final List<String> chords;

  /// Lyric text fragment positioned below [chord].
  final String lyric;

  /// Creates a [ChordLyricSegment] pair.
  ChordLyricSegment({this.chord, List<String>? chords, required this.lyric})
    : chords =
          chords ?? (chord != null && chord.isNotEmpty ? [chord] : const []);
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
      final directiveMatch = RegExp(r'^\{([a-zA-Z_]+)\s*:\s*(.+)\}$')
          .firstMatch(trimmed);
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
      final sectionOnlyMatch = RegExp(r'^\[([^\[\]]+)\]$').firstMatch(trimmed);
      if (sectionOnlyMatch != null) {
        final inside = sectionOnlyMatch.group(1)!.trim();
        if (ChordTransposer.splitCompoundChords(inside).isEmpty) {
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
      final initialParsed = _parseTokenWithSlashes(rawToken);

      final canStartTrailingSlashGroup =
          initialParsed.endsWithSlash &&
          i + 1 < matches.length &&
          line.substring(match.end, matches[i + 1].start).trim().isEmpty &&
          _parseTokenWithSlashes(matches[i + 1].group(1)!.trim())
              .chords
              .isNotEmpty;

      if (!initialParsed.startsWithSlash &&
          initialParsed.chords.isNotEmpty &&
          (!initialParsed.endsWithSlash || canStartTrailingSlashGroup)) {
        final groupChords = <String>[];
        for (final part in initialParsed.chords) {
          final transposed = ChordTransposer.transposeChord(
            part,
            transposeSemitones,
            preferFlats: preferFlats,
            targetKey: targetKey,
          );
          groupChords.add(transposed);
          uniqueChordsSet.add(transposed);
        }

        var hasTrailingSlash = initialParsed.endsWithSlash;

        // Merge chained chords separated by [/] (e.g. [D][/][F#m]),
        // trailing slash (e.g. [Bm/][A]), or leading slash (e.g. [Bm][/A]).
        while (i + 1 < matches.length &&
            line
                .substring(matches[i].end, matches[i + 1].start)
                .trim()
                .isEmpty) {
          final nextMatch = matches[i + 1];
          final nextToken = nextMatch.group(1)!.trim();
          final nextParsed = _parseTokenWithSlashes(nextToken);

          if (hasTrailingSlash && nextParsed.chords.isNotEmpty) {
            for (final part in nextParsed.chords) {
              final transposed = ChordTransposer.transposeChord(
                part,
                transposeSemitones,
                preferFlats: preferFlats,
                targetKey: targetKey,
              );
              groupChords.add(transposed);
              uniqueChordsSet.add(transposed);
            }
            hasTrailingSlash = nextParsed.endsWithSlash;
            i += 1;
            continue;
          }

          if (!hasTrailingSlash &&
              nextParsed.startsWithSlash &&
              nextParsed.chords.isNotEmpty) {
            for (final part in nextParsed.chords) {
              final transposed = ChordTransposer.transposeChord(
                part,
                transposeSemitones,
                preferFlats: preferFlats,
                targetKey: targetKey,
              );
              groupChords.add(transposed);
              uniqueChordsSet.add(transposed);
            }
            hasTrailingSlash = nextParsed.endsWithSlash;
            i += 1;
            continue;
          }

          if (!hasTrailingSlash &&
              nextToken == '/' &&
              i + 2 < matches.length &&
              line
                  .substring(nextMatch.end, matches[i + 2].start)
                  .trim()
                  .isEmpty) {
            final afterSepToken = matches[i + 2].group(1)!.trim();
            final afterSepParsed = _parseTokenWithSlashes(afterSepToken);
            if (afterSepParsed.chords.isNotEmpty) {
              for (final part in afterSepParsed.chords) {
                final transposed = ChordTransposer.transposeChord(
                  part,
                  transposeSemitones,
                  preferFlats: preferFlats,
                  targetKey: targetKey,
                );
                groupChords.add(transposed);
                uniqueChordsSet.add(transposed);
              }
              hasTrailingSlash = afterSepParsed.endsWithSlash;
              i += 2;
              continue;
            }
          }

          break;
        }

        final nextStart = (i + 1 < matches.length)
            ? matches[i + 1].start
            : line.length;
        final followingLyric = line.substring(matches[i].end, nextStart);

        // Split lyric into word chunks so long phrases wrap naturally in Flutter Wrap
        _appendWordSegments(
          segments,
          chords: groupChords,
          lyric: followingLyric,
        );
      } else {
        final nextStart = (i + 1 < matches.length)
            ? matches[i + 1].start
            : line.length;
        final followingLyric = line.substring(match.end, nextStart);
        segments.add(
          ChordLyricSegment(lyric: '[${match.group(1)}]$followingLyric'),
        );
      }
    }

    return segments;
  }

  static ({List<String> chords, bool startsWithSlash, bool endsWithSlash})
  _parseTokenWithSlashes(String token) {
    final trimmed = token.trim();
    if (trimmed.isEmpty || trimmed == '/') {
      return (chords: const [], startsWithSlash: false, endsWithSlash: false);
    }
    final startsWithSlash = trimmed.startsWith('/');
    final endsWithSlash = trimmed.length > 1 && trimmed.endsWith('/');
    final stripped = trimmed
        .replaceFirst(RegExp(r'^/'), '')
        .replaceFirst(RegExp(r'/$'), '')
        .trim();
    if (stripped.isEmpty) {
      return (chords: const [], startsWithSlash: false, endsWithSlash: false);
    }
    return (
      chords: ChordTransposer.splitCompoundChords(stripped),
      startsWithSlash: startsWithSlash,
      endsWithSlash: endsWithSlash,
    );
  }

  static void _appendWordSegments(
    List<ChordLyricSegment> target, {
    required List<String> chords,
    required String lyric,
  }) {
    final combinedChord = chords.join('/');
    if (lyric.isEmpty) {
      target.add(
        ChordLyricSegment(chord: combinedChord, chords: chords, lyric: ''),
      );
      return;
    }

    // Keep first word (and trailing space) attached to the chord, and split remaining words
    // so that long lines wrap gracefully on narrow screens without breaking chord alignment.
    final wordMatches = RegExp(r'\S+\s*|\s+').allMatches(lyric).toList();
    if (wordMatches.isEmpty) {
      target.add(
        ChordLyricSegment(chord: combinedChord, chords: chords, lyric: lyric),
      );
      return;
    }

    target.add(
      ChordLyricSegment(
        chord: combinedChord,
        chords: chords,
        lyric: wordMatches.first.group(0)!,
      ),
    );

    for (int i = 1; i < wordMatches.length; i++) {
      target.add(ChordLyricSegment(lyric: wordMatches[i].group(0)!));
    }
  }
}
