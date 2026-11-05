import 'package:flutter/material.dart';
import '../models/chord_model.dart';
import '../models/circle_of_fifths_model.dart';
import '../models/harmonic_progression_model.dart';
import 'chord_inspector_sheet.dart';

/// Interactive Progression Builder and Harmonic Analyzer widget with Roman Numeral Notation.
///
/// Features:
/// - Popular standard progression presets (Axis of Awesome, Jazz ii-V-I, 12-Bar Blues, Canon, Doo-Wop)
/// - Automatic Roman numeral degree analysis (I, ii, iii, IV, V, vi, vii°)
/// - Passing chords and modulation suggestions (Secondary Dominants V/V, V/vi, borrowed chords)
/// - Interactive chord taps opening instrument diagrams (Guitar, Ukulele, Piano)
class ProgressionBuilderWidget extends StatefulWidget {
  /// Current key from the Circle of Fifths (e.g., `'C'`, `'G'`).
  final String activeKey;

  /// Whether to allow the user to change the active key directly.
  final bool showKeySelector;

  /// Optional callback when a chord in the progression is tapped.
  final ValueChanged<String>? onChordTap;

  /// Creates a [ProgressionBuilderWidget].
  const ProgressionBuilderWidget({
    super.key,
    this.activeKey = 'C',
    this.showKeySelector = true,
    this.onChordTap,
  });

  @override
  State<ProgressionBuilderWidget> createState() =>
      _ProgressionBuilderWidgetState();
}

class _ProgressionBuilderWidgetState extends State<ProgressionBuilderWidget> {
  late String _key;
  late HarmonicProgression _selectedProgression;
  late List<ProgressionStep> _customSteps;

  @override
  void initState() {
    super.initState();
    _key = widget.activeKey;
    _selectedProgression = HarmonicProgression.standardTemplates.first;
    _customSteps = List.from(_selectedProgression.steps);
  }

  @override
  void didUpdateWidget(covariant ProgressionBuilderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeKey != oldWidget.activeKey) {
      _key = widget.activeKey;
    }
  }

  void _selectTemplate(HarmonicProgression template) {
    setState(() {
      _selectedProgression = template;
      _customSteps = List.from(template.steps);
    });
  }

  void _addSuggestedStep(ProgressionStep step) {
    setState(() {
      _customSteps.add(step);
    });
  }

  void _removeStepAt(int index) {
    if (_customSteps.length <= 1) return;
    setState(() {
      _customSteps.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final passingChords = HarmonicProgression.getPassingChordSuggestions(_key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header & Key Picker
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harmonic Progression',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Roman numeral harmonic analysis',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (widget.showKeySelector)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    value: _key,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    items: CircleOfFifthsModel.defaultKeys.map((k) {
                      return DropdownMenuItem<String>(
                        value: k.major,
                        child: Text('${k.major} Major'),
                      );
                    }).toList(),
                    onChanged: (newKey) {
                      if (newKey != null) {
                        setState(() {
                          _key = newKey;
                        });
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Template Selector Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: HarmonicProgression.standardTemplates.map((template) {
              final isSelected = template.name == _selectedProgression.name;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(template.name.split('(').first.trim()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) _selectTemplate(template);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Description Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _selectedProgression.description,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Active Progression Cards (Roman Numeral + Chord Symbol)
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(_customSteps.length, (index) {
            final step = _customSteps[index];
            final rootIndex = ChordTransposer.noteToSemitone(_key);
            final chordRoot = ChordTransposer.semitoneToNote(
              rootIndex + step.semitoneOffset,
              preferFlats: ChordTransposer.prefersFlatsForKey(_key),
            );
            final chordSymbol = '$chordRoot${step.quality}';

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                widget.onChordTap?.call(chordSymbol);
                ChordInspectorSheet.show(
                  context,
                  chordSymbol: chordSymbol,
                );
              },
              child: Container(
                width: 90,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Step index / Delete button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 9,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Text(
                            '${index + 1}',
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        if (_customSteps.length > 2)
                          InkWell(
                            onTap: () => _removeStepAt(index),
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Roman Numeral
                    Text(
                      step.romanNumeral,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Concrete Chord
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        chordSymbol,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Function Label
                    Text(
                      step.functionName.split(' ').first,
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),

        // Passing Chords & Modulations Suggestion Section
        Text(
          'Passing Chords & Secondary Dominants (Tap to add):',
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: passingChords.map((step) {
            final rootIndex = ChordTransposer.noteToSemitone(_key);
            final chordRoot = ChordTransposer.semitoneToNote(
              rootIndex + step.semitoneOffset,
              preferFlats: ChordTransposer.prefersFlatsForKey(_key),
            );
            final chordSymbol = '$chordRoot${step.quality}';

            return ActionChip(
              avatar: const Icon(Icons.add_rounded, size: 16),
              label: Text('${step.romanNumeral} ($chordSymbol)'),
              tooltip: step.functionName,
              onPressed: () => _addSuggestedStep(step),
            );
          }).toList(),
        ),
      ],
    );
  }
}
