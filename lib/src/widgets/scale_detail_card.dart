import 'package:material_ui/material_ui.dart';

import '../models/chord_model.dart';
import '../models/circle_of_fifths_model.dart';
import '../theme/circle_of_fifths_labels.dart';
import 'chord_inspector_sheet.dart';
import 'piano_keybed_widget.dart';

/// Card widget showing the scale notes, degree numbers (1-8), halftone interval formulas,
/// interactive chord diagram inspection on degree tap, and an optional Piano scale view.
class ScaleDetailCard extends StatelessWidget {
  /// The [CircleOfFifthsModel] providing notes and diatonic scale data.
  final CircleOfFifthsModel model;

  /// Whether the card displays Major mode or Relative Minor mode scale notes.
  final bool isMinorMode;

  /// Whether to render an interactive [PianoKeybedWidget] highlighting the scale notes.
  final bool showPianoScale;

  /// Whether tapping a scale degree opens [ChordInspectorSheet] for that degree's chord.
  final bool enableChordTap;

  /// Default instrument tab when opening [ChordInspectorSheet] on degree tap.
  final InstrumentType defaultInstrument;

  /// Custom localization labels.
  final CircleOfFifthsLabels labels;

  /// Optional background color for the card container.
  /// Defaults to [ColorScheme.surfaceContainerHigh] (or [ColorScheme.surfaceContainerLow] / surface).
  final Color? backgroundColor;

  /// Optional accent color for the scale title, active notes, and tonic highlights.
  /// Defaults to [ColorScheme.primary].
  final Color? primaryColor;

  /// Optional secondary color for interval formula labels and connectors.
  /// Defaults to [ColorScheme.secondary].
  final Color? secondaryColor;

  /// Optional border color for the card outline.
  /// Defaults to [ColorScheme.outlineVariant].
  final Color? borderColor;

  /// Creates a [ScaleDetailCard] widget displaying scale notes and interval formula.
  const ScaleDetailCard({
    super.key,
    required this.model,
    this.isMinorMode = false,
    this.showPianoScale = false,
    this.enableChordTap = true,
    this.defaultInstrument = InstrumentType.guitar,
    this.labels = const CircleOfFifthsLabels(),
    this.backgroundColor,
    this.primaryColor,
    this.secondaryColor,
    this.borderColor,
  });

  String _formatDegreeNote(String note, int index) {
    if (!isMinorMode) {
      switch (index) {
        case 0:
        case 3:
        case 4:
        case 7:
          return note.toUpperCase();
        case 1:
        case 2:
        case 5:
          return note.toLowerCase();
        case 6:
          return '${note}dis';
        default:
          return note;
      }
    } else {
      switch (index) {
        case 0:
        case 3:
        case 4:
        case 7:
          return note.toLowerCase();
        case 1:
          return '${note}dis';
        case 2:
        case 5:
        case 6:
          return note.toUpperCase();
        default:
          return note;
      }
    }
  }

  String _chordSymbolForDegree(String rawNote, int index) {
    if (!isMinorMode) {
      switch (index) {
        case 1:
        case 2:
        case 5:
          return '${rawNote}m';
        case 6:
          return '${rawNote}dim';
        default:
          return rawNote;
      }
    } else {
      switch (index) {
        case 0:
        case 3:
        case 4:
        case 7:
          return '${rawNote}m';
        case 1:
          return '${rawNote}dim';
        default:
          return rawNote;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectivePrimaryColor = primaryColor ?? colorScheme.primary;
    final effectiveSecondaryColor = secondaryColor ?? colorScheme.secondary;
    final effectiveBgColor =
        backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLowest);
    final effectiveBorderColor =
        borderColor ?? colorScheme.outlineVariant.withValues(alpha: 0.5);

    final intervals = isMinorMode
        ? const ['2', '1', '2', '2', '1', '2', '2']
        : const ['2', '2', '1', '2', '2', '2', '1'];

    final notes = isMinorMode ? model.minorScaleNotes : model.majorScaleNotes;
    final scaleTitle = isMinorMode
        ? '${model.minor.toUpperCase()}m ${labels.minorLabel} ${model.major})'
        : '${model.major} ${labels.majorLabel}';

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: effectiveBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    scaleTitle,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (enableChordTap)
                  Text(
                    labels.tapDegreeForChordHint,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Scale notes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(notes.length, (index) {
                final rawNote = notes[index];
                final formattedNote = _formatDegreeNote(rawNote, index);
                final chordSymbol = _chordSymbolForDegree(rawNote, index);

                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: enableChordTap
                      ? () => ChordInspectorSheet.show(
                          context,
                          chordSymbol: chordSymbol,
                          initialInstrument: defaultInstrument,
                          labels: labels,
                        )
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Column(
                      children: [
                        Text(
                          formattedNote,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: effectivePrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: primaryColor != null
                              ? primaryColor!.withValues(alpha: 0.15)
                              : colorScheme.primaryContainer,
                          child: Text(
                            '${index + 1}',
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color:
                                  primaryColor ??
                                  colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),

            // Interval connectors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(intervals.length, (index) {
                return Row(
                  children: [
                    Icon(
                      Icons.arrow_right_alt_rounded,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      intervals[index],
                      style: textTheme.labelSmall?.copyWith(
                        color: effectiveSecondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
            ),

            if (showPianoScale) ...[
              const SizedBox(height: 16),
              PianoKeybedWidget(
                highlightedNotes: notes.sublist(0, 7),
                rootNote: notes.first,
                octaves: 2,
                height: 120,
                preferFlats: model.keySignature.contains('b'),
                rootKeyColor: primaryColor,
                activeKeyColor:
                    secondaryColor ?? primaryColor?.withValues(alpha: 0.25),
                activeBlackKeyColor: secondaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
