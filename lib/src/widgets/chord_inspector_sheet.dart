import 'package:flutter/material.dart';
import '../models/chord_model.dart';
import 'fretboard_widget.dart';
import 'piano_keybed_widget.dart';

/// Interactive Material 3 card and modal sheet that displays a chord's constituent
/// notes, interval formula, and interactive diagrams for Guitar, Ukulele, and Piano.
class ChordInspectorSheet extends StatefulWidget {
  /// Parsed chord information to inspect.
  final ChordInfo chordInfo;

  /// Initial instrument tab to show (`guitar`, `ukulele`, or `piano`).
  final InstrumentType initialInstrument;

  /// Creates a [ChordInspectorSheet] widget.
  const ChordInspectorSheet({
    super.key,
    required this.chordInfo,
    this.initialInstrument = InstrumentType.guitar,
  });

  /// Convenience helper to open a Material 3 modal bottom sheet inspecting [chordSymbol].
  static Future<void> show(
    BuildContext context, {
    required String chordSymbol,
    InstrumentType initialInstrument = InstrumentType.guitar,
  }) {
    final info = ChordTransposer.parseChord(chordSymbol);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: ChordInspectorSheet(
          chordInfo: info,
          initialInstrument: initialInstrument,
        ),
      ),
    );
  }

  @override
  State<ChordInspectorSheet> createState() => _ChordInspectorSheetState();
}

class _ChordInspectorSheetState extends State<ChordInspectorSheet> {
  late InstrumentType _selectedInstrument;

  @override
  void initState() {
    super.initState();
    _selectedInstrument = widget.initialInstrument;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final info = widget.chordInfo;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),

        // Chord Title & Root/Quality Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    info.symbol,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Root: ${info.root}${info.bassNote != null ? ' (Bass: ${info.bassNote})' : ''}',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Intervals: ${info.intervalLabels.join(' - ')}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Close',
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Constituent Notes Chips
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Notes:',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              for (int i = 0; i < info.notes.length; i++)
                Chip(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: i == 0
                      ? colorScheme.primary
                      : colorScheme.secondaryContainer,
                  label: Text(
                    info.notes[i],
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: i == 0
                          ? colorScheme.onPrimary
                          : colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Instrument Selector
        SegmentedButton<InstrumentType>(
          segments: const [
            ButtonSegment(
              value: InstrumentType.guitar,
              label: Text('Guitar'),
              icon: Icon(Icons.music_note_rounded),
            ),
            ButtonSegment(
              value: InstrumentType.ukulele,
              label: Text('Ukulele'),
              icon: Icon(Icons.audiotrack_rounded),
            ),
            ButtonSegment(
              value: InstrumentType.piano,
              label: Text('Piano'),
              icon: Icon(Icons.piano_rounded),
            ),
          ],
          selected: {_selectedInstrument},
          onSelectionChanged: (selection) {
            setState(() {
              _selectedInstrument = selection.first;
            });
          },
        ),
        const SizedBox(height: 20),

        // Diagram View
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _buildInstrumentDiagram(info),
        ),
      ],
    );
  }

  Widget _buildInstrumentDiagram(ChordInfo info) {
    switch (_selectedInstrument) {
      case InstrumentType.guitar:
        return Center(
          key: const ValueKey('guitar'),
          child: FretboardWidget(
            voicing: info.guitarVoicing,
            width: 220,
            height: 230,
          ),
        );
      case InstrumentType.ukulele:
        return Center(
          key: const ValueKey('ukulele'),
          child: FretboardWidget(
            voicing: info.ukuleleVoicing,
            width: 180,
            height: 230,
          ),
        );
      case InstrumentType.piano:
        return Padding(
          key: const ValueKey('piano'),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: PianoKeybedWidget(
            highlightedNotes: info.notes,
            rootNote: info.root,
            octaves: 2,
            height: 160,
            preferFlats: info.root.contains('b'),
          ),
        );
    }
  }
}
