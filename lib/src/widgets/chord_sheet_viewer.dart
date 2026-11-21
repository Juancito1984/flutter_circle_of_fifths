import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../models/chord_model.dart';
import '../models/chord_sheet_parser.dart';
import '../models/circle_of_fifths_model.dart';
import '../theme/circle_of_fifths_labels.dart';
import 'chord_inspector_sheet.dart';

/// Interactive Material 3 ChordPro / Bracket-notation viewer and transposition widget.
///
/// Renders lyrics with aligned clickable chord badges above each syllable, supports
/// semitone transposition (`+1` / `-1`) and direct Circle of Fifths key transposition,
/// and opens an interactive chord diagram modal when a chord is tapped.
class ChordSheetViewer extends StatefulWidget {
  /// Song text in Bracket / ChordPro format (e.g., `"[C]Amazing [F]grace..."`).
  final String songText;

  /// Original musical key of the song (e.g., `"C"`, `"G"`, `"Am"`).
  /// Used to synchronize transposition with the Circle of Fifths.
  final String? originalKey;

  /// Initial transposition offset in semitones (`-11`..`+11`).
  final int initialTransposeSemitones;

  /// Optional external target key from the Circle of Fifths (e.g., `"F#"`, `"Eb"`).
  /// When provided, automatically computes the semitone distance from [originalKey]
  /// and adapts enharmonic accidentals (`#` vs `b`) to match the Circle of Fifths key signature.
  final String? targetKey;

  /// Whether to show the built-in transposition and key selector toolbar at the top.
  final bool showTranspositionBar;

  /// Whether to show a summary bar of all unique chords in the song.
  final bool showChordSummaryBar;

  /// Whether tapping a chord automatically opens [ChordInspectorSheet] with
  /// Guitar, Ukulele, and Piano diagrams.
  final bool showDiagramModalOnTap;

  /// Whether to display chords above the lyrics.
  /// When set to `false`, chords and chord spaces are hidden, rendering lyrics only.
  /// Defaults to `true`.
  final bool showChords;

  /// Default instrument tab when opening the chord inspector modal.
  final InstrumentType defaultInstrument;

  /// Custom localization labels.
  final CircleOfFifthsLabels labels;

  /// Optional callback triggered whenever a chord is tapped.
  final ValueChanged<ChordInfo>? onTapChord;

  /// Optional callback triggered when the transposition semitone offset changes.
  final ValueChanged<int>? onTransposeChanged;

  /// Custom text style for song lyrics.
  final TextStyle? lyricStyle;

  /// Custom text style for chord badges above lyrics.
  final TextStyle? chordStyle;

  /// Optional background color for the chord badge container.
  /// If null, defaults to [ColorScheme.primaryContainer].
  final Color? chordBackgroundColor;

  /// Custom text style for section headers (`[Verse]`, `[Chorus]`).
  final TextStyle? sectionStyle;

  /// Horizontal spacing between word chunks in a line.
  final double wordSpacing;

  /// Vertical spacing between wrapped segments when a single line wraps to the next line.
  final double lineRunSpacing;

  /// Vertical spacing between consecutive song lines (interlineado entre versos).
  final double lineSpacing;

  /// Vertical spacing between verses/stanzas (separación entre estrofas/líneas vacías).
  /// Defaults to `16.0`.
  final double stanzaSpacing;

  /// Vertical spacing between chord badge and lyric text underneath.
  final double chordToLyricSpacing;

  /// Alignment mode for braced chord-over-lyric lines (e.g. `{  Dm   F#m   C}`).
  ///
  /// Defaults to [ChordLineAlignment.auto], which automatically adapts between
  /// monospace character-column alignment and proportional `TextField` visual
  /// width alignment.
  final ChordLineAlignment chordLineAlignment;

  /// Creates a [ChordSheetViewer] widget.
  const ChordSheetViewer({
    super.key,
    required this.songText,
    this.originalKey = 'C',
    this.initialTransposeSemitones = 0,
    this.targetKey,
    this.showTranspositionBar = true,
    this.showChordSummaryBar = true,
    this.showDiagramModalOnTap = true,
    this.showChords = true,
    this.defaultInstrument = InstrumentType.guitar,
    this.labels = const CircleOfFifthsLabels(),
    this.onTapChord,
    this.onTransposeChanged,
    this.lyricStyle,
    this.chordStyle,
    this.chordBackgroundColor,
    this.sectionStyle,
    this.wordSpacing = 4.0,
    this.lineRunSpacing = 8.0,
    this.lineSpacing = 8.0,
    this.stanzaSpacing = 16.0,
    this.chordToLyricSpacing = 2.0,
    this.chordLineAlignment = ChordLineAlignment.auto,
  });

  @override
  State<ChordSheetViewer> createState() => _ChordSheetViewerState();
}

class _ChordSheetViewerState extends State<ChordSheetViewer> {
  late int _semitones;
  String? _selectedTargetKey;

  @override
  void initState() {
    super.initState();
    _selectedTargetKey = widget.targetKey;
    if (_selectedTargetKey != null && widget.originalKey != null) {
      _semitones = ChordTransposer.semitonesBetweenKeys(
        widget.originalKey!,
        _selectedTargetKey!,
      );
    } else {
      _semitones = widget.initialTransposeSemitones;
    }
  }

  @override
  void didUpdateWidget(covariant ChordSheetViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetKey != oldWidget.targetKey && widget.targetKey != null) {
      _selectedTargetKey = widget.targetKey;
      if (widget.originalKey != null) {
        _semitones = ChordTransposer.semitonesBetweenKeys(
          widget.originalKey!,
          widget.targetKey!,
        );
      }
    } else if (widget.initialTransposeSemitones !=
        oldWidget.initialTransposeSemitones) {
      _semitones = widget.initialTransposeSemitones;
    }
  }

  void _updateTranspose(int newSemitones) {
    int normalized = newSemitones % 12;
    if (normalized > 6) normalized -= 12;
    if (normalized < -6) normalized += 12;

    setState(() {
      _semitones = normalized;
      if (widget.originalKey != null) {
        _selectedTargetKey = ChordTransposer.transposeChord(
          widget.originalKey!,
          _semitones,
        );
      }
    });
    widget.onTransposeChanged?.call(_semitones);
  }

  void _selectCircleKey(String majorKey) {
    final baseKey = widget.originalKey ?? 'C';
    final diff = ChordTransposer.semitonesBetweenKeys(baseKey, majorKey);
    setState(() {
      _semitones = diff;
      _selectedTargetKey = majorKey;
    });
    widget.onTransposeChanged?.call(_semitones);
  }

  void _handleChordTap(String chordSymbol) {
    final preferFlats = ChordTransposer.prefersFlatsForKey(_selectedTargetKey);
    final info = ChordTransposer.parseChord(
      chordSymbol,
      preferFlats: preferFlats,
    );
    widget.onTapChord?.call(info);
    if (widget.showDiagramModalOnTap) {
      ChordInspectorSheet.show(
        context,
        chordSymbol: chordSymbol,
        initialInstrument: widget.defaultInstrument,
        labels: widget.labels,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectiveKey =
        _selectedTargetKey ??
        (widget.originalKey != null
            ? ChordTransposer.transposeChord(widget.originalKey!, _semitones)
            : null);

    final defaultLyricStyle =
        widget.lyricStyle ??
        textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
          height: 1.35,
        ) ??
        const TextStyle(fontSize: 16);

    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final widthCache = <String, double>{};
    double measureLyricWidth(String text) {
      return widthCache.putIfAbsent(text, () {
        if (text.isEmpty) return 0.0;
        final painter = TextPainter(
          text: TextSpan(text: text, style: defaultLyricStyle),
          textDirection: textDirection,
          maxLines: 1,
        )..layout();
        return painter.width;
      });
    }

    final doc = ChordSheetDocument.parse(
      widget.songText,
      transposeSemitones: _semitones,
      targetKey: effectiveKey,
      chordLineAlignment: widget.chordLineAlignment,
      measureTextWidth: measureLyricWidth,
    );

    final defaultChordStyle =
        widget.chordStyle ??
        textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ) ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

    final defaultSectionStyle =
        widget.sectionStyle ??
        textTheme.titleSmall?.copyWith(
          color: colorScheme.secondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.6,
        ) ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showChords && widget.showTranspositionBar) ...[
            _buildTranspositionToolbar(context, effectiveKey),
            const SizedBox(height: 12),
          ],
          if (widget.showChords &&
              widget.showChordSummaryBar &&
              doc.uniqueChords.isNotEmpty) ...[
            _buildUniqueChordsBar(context, doc.uniqueChords),
            const SizedBox(height: 16),
          ],
          for (final line in doc.lines)
            _buildLine(
              context,
              line,
              lyricStyle: defaultLyricStyle,
              chordStyle: defaultChordStyle,
              sectionStyle: defaultSectionStyle,
            ),
        ],
      ),
    );
  }

  Widget _buildTranspositionToolbar(
    BuildContext context,
    String? effectiveKey,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final labels = widget.labels;

    final semitoneLabel = _semitones > 0 ? '+$_semitones' : '$_semitones';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 460;

          final semitoneStepper = Row(
            mainAxisSize: isCompact ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Icon(
                Icons.swap_vert_circle_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                labels.transposeLabel,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isCompact) const Spacer() else const SizedBox(width: 6),
              if (_semitones != 0)
                TextButton(
                  onPressed: () => _updateTranspose(0),
                  child: Text(labels.resetLabel),
                ),
              IconButton.filledTonal(
                visualDensity: VisualDensity.compact,
                onPressed: () => _updateTranspose(_semitones - 1),
                icon: const Icon(Icons.remove_rounded, size: 18),
                tooltip: '-1 Semitone',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  semitoneLabel,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _semitones == 0
                        ? colorScheme.onSurface
                        : colorScheme.primary,
                  ),
                ),
              ),
              IconButton.filledTonal(
                visualDensity: VisualDensity.compact,
                onPressed: () => _updateTranspose(_semitones + 1),
                icon: const Icon(Icons.add_rounded, size: 18),
                tooltip: '+1 Semitone',
              ),
            ],
          );

          final dropdownBox = Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              isDense: true,
              isExpanded: isCompact,
              value:
                  CircleOfFifthsModel.defaultKeys.any(
                    (k) => k.major == effectiveKey,
                  )
                  ? effectiveKey
                  : CircleOfFifthsModel.defaultKeys.first.major,
              dropdownColor: colorScheme.surfaceContainerHighest,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
              items: CircleOfFifthsModel.defaultKeys.map((model) {
                return DropdownMenuItem<String>(
                  value: model.major,
                  child: Text(
                    '${model.major} / ${model.minor}m (${model.keySignature})',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newKey) {
                if (newKey != null) {
                  _selectCircleKey(newKey);
                }
              },
            ),
          );

          final keySelector = Row(
            mainAxisSize: isCompact ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Text(
                labels.keyLabel,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              if (isCompact)
                Expanded(child: DropdownButtonHideUnderline(child: dropdownBox))
              else
                DropdownButtonHideUnderline(child: dropdownBox),
            ],
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                semitoneStepper,
                const SizedBox(height: 8),
                keySelector,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              semitoneStepper,
              const SizedBox(width: 12),
              Flexible(child: keySelector),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUniqueChordsBar(BuildContext context, List<String> chords) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app_rounded,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  widget.labels.uniqueChordsLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final chord in chords)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      visualDensity: VisualDensity.compact,
                      backgroundColor: colorScheme.secondaryContainer,
                      label: Text(
                        chord,
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      onPressed: () => _handleChordTap(chord),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(
    BuildContext context,
    ChordSheetLine line, {
    required TextStyle lyricStyle,
    required TextStyle chordStyle,
    required TextStyle sectionStyle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    switch (line.type) {
      case ChordSheetLineType.empty:
        return SizedBox(height: widget.stanzaSpacing);
      case ChordSheetLineType.title:
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            line.headerText ?? '',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        );
      case ChordSheetLineType.subtitle:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            line.headerText ?? '',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        );
      case ChordSheetLineType.section:
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(line.headerText ?? '', style: sectionStyle),
          ),
        );
      case ChordSheetLineType.chordLyrics:
        final hasAnyChord =
            widget.showChords &&
            line.segments.any(
              (s) =>
                  s.chords.isNotEmpty ||
                  (s.chord != null && s.chord!.isNotEmpty),
            );
        final fullLineText = line.segments.map((s) => s.lyric).join();

        // When showChords is false or the line has no chords, render pure Text
        // for pixel-perfect font spacing, line-height, and text selection.
        if (!widget.showChords || !hasAnyChord) {
          if (fullLineText.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: EdgeInsets.only(bottom: widget.lineSpacing),
            child: Text(fullLineText, style: lyricStyle),
          );
        }

        // Standalone chord-only line (e.g. instrumental intro/interlude)
        if (fullLineText.isEmpty) {
          final chordSegments = line.segments
              .where((s) => _chordsForSegment(s).isNotEmpty)
              .toList();
          return Padding(
            padding: EdgeInsets.only(bottom: widget.lineSpacing),
            child: Wrap(
              spacing: math.max(6.0, widget.wordSpacing),
              runSpacing: widget.lineRunSpacing,
              children: [
                for (final segment in chordSegments)
                  _buildChordBadge(
                    context,
                    _chordsForSegment(segment),
                    chordStyle: chordStyle,
                  ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: widget.lineSpacing),
          child: _buildAlignedChordLyricLine(
            context,
            line.segments,
            fullLineText: fullLineText,
            lyricStyle: lyricStyle,
            chordStyle: chordStyle,
          ),
        );
    }
  }

  List<String> _chordsForSegment(ChordLyricSegment segment) {
    if (!widget.showChords) return const [];
    if (segment.chords.isNotEmpty) return segment.chords;
    if (segment.chord != null && segment.chord!.isNotEmpty) {
      return [segment.chord!];
    }
    return const [];
  }

  Widget _buildAlignedChordLyricLine(
    BuildContext context,
    List<ChordLyricSegment> segments, {
    required String fullLineText,
    required TextStyle lyricStyle,
    required TextStyle chordStyle,
  }) {
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;

    // Collect each chord anchor with its exact character offset in fullLineText.
    final anchors = <({int charIndex, List<String> chords})>[];
    var runningOffset = 0;
    for (final segment in segments) {
      final chords = _chordsForSegment(segment);
      if (chords.isNotEmpty) {
        anchors.add((charIndex: runningOffset, chords: chords));
      }
      runningOffset += segment.lyric.length;
    }

    // Measure standard badge height from chordStyle so any font size fits cleanly.
    final badgeMetricsPainter = TextPainter(
      text: TextSpan(text: 'Mg', style: chordStyle),
      textDirection: textDirection,
      maxLines: 1,
    )..layout();
    final badgeHeight = badgeMetricsPainter.height + 4.0;

    final badgeWidthCache = <String, double>{};
    double measureBadgeWidth(List<String> chords) {
      final label = chords.join('/');
      return badgeWidthCache.putIfAbsent(label, () {
        final painter = TextPainter(
          text: TextSpan(text: label, style: chordStyle),
          textDirection: textDirection,
          maxLines: 1,
        )..layout();
        // Horizontal padding 6 + 6 = 12, plus slight rounding margin
        return painter.width + 13.0;
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 10000.0;

        final fullPainter = TextPainter(
          text: TextSpan(text: fullLineText, style: lyricStyle),
          textDirection: textDirection,
        )..layout(maxWidth: maxWidth);

        final wrappedRanges = <({int start, int end})>[];
        var offset = 0;
        while (offset < fullLineText.length) {
          final boundary = fullPainter.getLineBoundary(
            TextPosition(offset: offset),
          );
          var start = boundary.start;
          var end = boundary.end;
          if (start < offset) start = offset;
          if (end <= start) {
            end = math.min(fullLineText.length, start + 1);
          }
          wrappedRanges.add((start: start, end: end));
          offset = end;
        }

        if (wrappedRanges.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (
              var lineIdx = 0;
              lineIdx < wrappedRanges.length;
              lineIdx++
            ) ...[
              if (lineIdx > 0) SizedBox(height: widget.lineRunSpacing),
              _buildPhysicalChordLyricSubLine(
                context,
                subText: fullLineText.substring(
                  wrappedRanges[lineIdx].start,
                  wrappedRanges[lineIdx].end,
                ),
                isLastWrappedLine: lineIdx == wrappedRanges.length - 1,
                lineStartOffset: wrappedRanges[lineIdx].start,
                lineEndOffset: wrappedRanges[lineIdx].end,
                fullLength: fullLineText.length,
                allAnchors: anchors,
                maxWidth: maxWidth,
                textDirection: textDirection,
                lyricStyle: lyricStyle,
                chordStyle: chordStyle,
                badgeHeight: badgeHeight,
                measureBadgeWidth: measureBadgeWidth,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPhysicalChordLyricSubLine(
    BuildContext context, {
    required String subText,
    required bool isLastWrappedLine,
    required int lineStartOffset,
    required int lineEndOffset,
    required int fullLength,
    required List<({int charIndex, List<String> chords})> allAnchors,
    required double maxWidth,
    required TextDirection textDirection,
    required TextStyle lyricStyle,
    required TextStyle chordStyle,
    required double badgeHeight,
    required double Function(List<String> chords) measureBadgeWidth,
  }) {
    final lineAnchors = <({int subIndex, List<String> chords})>[];
    for (final a in allAnchors) {
      if (a.charIndex >= lineStartOffset && a.charIndex < lineEndOffset) {
        lineAnchors.add((
          subIndex: a.charIndex - lineStartOffset,
          chords: a.chords,
        ));
      } else if (isLastWrappedLine && a.charIndex >= fullLength) {
        lineAnchors.add((subIndex: subText.length, chords: a.chords));
      }
    }

    final displaySubText = isLastWrappedLine ? subText : subText.trimRight();
    if (lineAnchors.isEmpty) {
      return Text(displaySubText, style: lyricStyle);
    }

    double measureSubWidth(int endIndex) {
      final safeEnd = endIndex.clamp(0, displaySubText.length);
      if (safeEnd == 0) return 0.0;
      final painter = TextPainter(
        text: TextSpan(
          text: displaySubText.substring(0, safeEnd),
          style: lyricStyle,
        ),
        textDirection: textDirection,
        maxLines: 1,
      )..layout();
      return painter.width;
    }

    const minChordGap = 4.0;
    final gapAtSubIndex = <int, double>{};
    final placedChords = <({double x, List<String> chords})>[];

    var prevRight = -double.infinity;
    var accumulatedGap = 0.0;

    for (var i = 0; i < lineAnchors.length; i++) {
      final anchor = lineAnchors[i];
      final badgeW = measureBadgeWidth(anchor.chords);
      final isTrailingAfterText = anchor.subIndex >= displaySubText.length;
      final baseRawX = measureSubWidth(anchor.subIndex);
      var desiredX = baseRawX + accumulatedGap;

      if (isTrailingAfterText) {
        desiredX = math.max(
          desiredX + math.max(4.0, widget.wordSpacing),
          prevRight + minChordGap,
        );
      } else if (desiredX < prevRight + minChordGap) {
        final extraGap = (prevRight + minChordGap) - desiredX;
        gapAtSubIndex[anchor.subIndex] =
            (gapAtSubIndex[anchor.subIndex] ?? 0.0) + extraGap;
        accumulatedGap += extraGap;
        desiredX = prevRight + minChordGap;
      }

      // Keep the last chord from clipping past the right edge when space allows.
      if (i == lineAnchors.length - 1 &&
          desiredX + badgeW > maxWidth &&
          maxWidth - badgeW >= prevRight + minChordGap) {
        desiredX = math.max(prevRight + minChordGap, maxWidth - badgeW);
      }

      placedChords.add((x: desiredX, chords: anchor.chords));
      prevRight = desiredX + badgeW;
    }

    final spans = <InlineSpan>[];
    if (gapAtSubIndex.isEmpty) {
      spans.add(TextSpan(text: displaySubText, style: lyricStyle));
    } else {
      final sortedIndices = gapAtSubIndex.keys.toList()..sort();
      var cursor = 0;
      for (final idx in sortedIndices) {
        final safeIdx = idx.clamp(0, displaySubText.length);
        if (safeIdx > cursor) {
          spans.add(
            TextSpan(
              text: displaySubText.substring(cursor, safeIdx),
              style: lyricStyle,
            ),
          );
          cursor = safeIdx;
        }
        spans.add(WidgetSpan(child: SizedBox(width: gapAtSubIndex[idx]!)));
      }
      if (cursor < displaySubText.length) {
        spans.add(
          TextSpan(text: displaySubText.substring(cursor), style: lyricStyle),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: badgeHeight,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final placed in placedChords)
                Positioned(
                  left: placed.x,
                  top: 0,
                  child: _buildChordBadge(
                    context,
                    placed.chords,
                    chordStyle: chordStyle,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: widget.chordToLyricSpacing),
        Text.rich(TextSpan(children: spans)),
      ],
    );
  }

  Widget _buildChordBadge(
    BuildContext context,
    List<String> displayChords, {
    required TextStyle chordStyle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final badgeBackground =
        widget.chordBackgroundColor ?? colorScheme.primaryContainer;
    final badgeTextColor =
        widget.chordStyle?.color ?? colorScheme.onPrimaryContainer;

    if (displayChords.length == 1) {
      return InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => _handleChordTap(displayChords.first),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: badgeBackground,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            displayChords.first,
            style: chordStyle.copyWith(color: badgeTextColor),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < displayChords.length; i++) ...[
            if (i > 0)
              Text(
                '/',
                style: chordStyle.copyWith(
                  color: badgeTextColor.withValues(alpha: 0.7),
                ),
              ),
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => _handleChordTap(displayChords[i]),
              child: Text(
                displayChords[i],
                style: chordStyle.copyWith(color: badgeTextColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
