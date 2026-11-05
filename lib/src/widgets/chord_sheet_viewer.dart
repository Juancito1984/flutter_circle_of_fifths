import 'package:flutter/material.dart';
import '../models/chord_model.dart';
import '../models/chord_sheet_parser.dart';
import '../models/circle_of_fifths_model.dart';
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

  /// Default instrument tab when opening the chord inspector modal.
  final InstrumentType defaultInstrument;

  /// Optional callback triggered whenever a chord is tapped.
  final ValueChanged<ChordInfo>? onTapChord;

  /// Optional callback triggered when the transposition semitone offset changes.
  final ValueChanged<int>? onTransposeChanged;

  /// Custom text style for song lyrics.
  final TextStyle? lyricStyle;

  /// Custom text style for chord badges above lyrics.
  final TextStyle? chordStyle;

  /// Custom text style for section headers (`[Verse]`, `[Chorus]`).
  final TextStyle? sectionStyle;

  /// Horizontal spacing between word chunks in a line.
  final double wordSpacing;

  /// Vertical spacing between wrapped segments in a line.
  final double lineRunSpacing;

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
    this.defaultInstrument = InstrumentType.guitar,
    this.onTapChord,
    this.onTransposeChanged,
    this.lyricStyle,
    this.chordStyle,
    this.sectionStyle,
    this.wordSpacing = 4.0,
    this.lineRunSpacing = 8.0,
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
    final preferFlats =
        ChordTransposer.prefersFlatsForKey(_selectedTargetKey);
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectiveKey = _selectedTargetKey ??
        (widget.originalKey != null
            ? ChordTransposer.transposeChord(widget.originalKey!, _semitones)
            : null);

    final doc = ChordSheetDocument.parse(
      widget.songText,
      transposeSemitones: _semitones,
      targetKey: effectiveKey,
    );

    final defaultLyricStyle = widget.lyricStyle ??
        textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
          height: 1.35,
        ) ??
        const TextStyle(fontSize: 16);

    final defaultChordStyle = widget.chordStyle ??
        textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ) ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

    final defaultSectionStyle = widget.sectionStyle ??
        textTheme.titleSmall?.copyWith(
          color: colorScheme.secondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.6,
        ) ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTranspositionBar) ...[
          _buildTranspositionToolbar(context, effectiveKey),
          const SizedBox(height: 12),
        ],
        if (widget.showChordSummaryBar && doc.uniqueChords.isNotEmpty) ...[
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
    );
  }

  Widget _buildTranspositionToolbar(
    BuildContext context,
    String? effectiveKey,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final semitoneLabel =
        _semitones > 0 ? '+$_semitones' : '$_semitones';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Semitone stepper
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.swap_vert_circle_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Transpose:',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
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
              if (_semitones != 0)
                TextButton(
                  onPressed: () => _updateTranspose(0),
                  child: const Text('Reset'),
                ),
            ],
          ),

          // Circle of Fifths Target Key Selector
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Key:',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    isDense: true,
                    value: CircleOfFifthsModel.defaultKeys.any(
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
                        child: Text('${model.major} / ${model.minor}m (${model.keySignature})'),
                      );
                    }).toList(),
                    onChanged: (newKey) {
                      if (newKey != null) {
                        _selectCircleKey(newKey);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUniqueChordsBar(BuildContext context, List<String> chords) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Icon(
            Icons.touch_app_rounded,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            'Chords (tap to view diagram):',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
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
        return const SizedBox(height: 12);
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
            child: Text(
              line.headerText ?? '',
              style: sectionStyle,
            ),
          ),
        );
      case ChordSheetLineType.chordLyrics:
        final hasAnyChord = line.segments.any(
          (s) => s.chord != null && s.chord!.isNotEmpty,
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Wrap(
            spacing: widget.wordSpacing,
            runSpacing: widget.lineRunSpacing,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: line.segments.map((segment) {
              return _buildSegment(
                context,
                segment,
                hasAnyChordInLine: hasAnyChord,
                lyricStyle: lyricStyle,
                chordStyle: chordStyle,
              );
            }).toList(),
          ),
        );
    }
  }

  Widget _buildSegment(
    BuildContext context,
    ChordLyricSegment segment, {
    required bool hasAnyChordInLine,
    required TextStyle lyricStyle,
    required TextStyle chordStyle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasChord = segment.chord != null && segment.chord!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasAnyChordInLine)
          hasChord
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => _handleChordTap(segment.chord!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        segment.chord!,
                        style: chordStyle.copyWith(
                          color: widget.chordStyle?.color ??
                              colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 24),
        if (segment.lyric.isNotEmpty)
          Text(
            segment.lyric,
            style: lyricStyle,
          ),
      ],
    );
  }
}
