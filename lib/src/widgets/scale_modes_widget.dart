import 'package:flutter/material.dart';
import '../models/chord_model.dart';
import '../models/circle_of_fifths_model.dart';
import '../models/scale_mode_model.dart';
import 'chord_inspector_sheet.dart';
import 'piano_keybed_widget.dart';

/// Interactive explorer widget for Gregorian church modes and advanced scales
/// (Pentatonics, Blues, Harmonic Minor, Melodic Minor).
class ScaleModesWidget extends StatefulWidget {
  /// Root note for scale generation (e.g., `'C'`, `'G'`). Defaults to `'C'`.
  final String rootNote;

  /// Whether to allow the user to change the root note with a selector.
  final bool showRootSelector;

  /// Whether to render an interactive piano keyboard displaying the scale notes.
  final bool showPianoKeyboard;

  /// Callback when a scale or mode is selected.
  final ValueChanged<ScaleFormula>? onScaleChanged;

  /// Creates a [ScaleModesWidget].
  const ScaleModesWidget({
    super.key,
    this.rootNote = 'C',
    this.showRootSelector = true,
    this.showPianoKeyboard = true,
    this.onScaleChanged,
  });

  @override
  State<ScaleModesWidget> createState() => _ScaleModesWidgetState();
}

class _ScaleModesWidgetState extends State<ScaleModesWidget> {
  late String _root;
  late ScaleFormula _selectedScale;
  int _categoryTab = 0; // 0: Modes, 1: Advanced

  @override
  void initState() {
    super.initState();
    _root = widget.rootNote;
    _selectedScale = ScaleFormula.gregorianModes.first;
  }

  @override
  void didUpdateWidget(covariant ScaleModesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rootNote != oldWidget.rootNote) {
      _root = widget.rootNote;
    }
  }

  void _onSelectScale(ScaleFormula formula) {
    setState(() {
      _selectedScale = formula;
    });
    widget.onScaleChanged?.call(formula);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final scalesList = _categoryTab == 0
        ? ScaleFormula.gregorianModes
        : ScaleFormula.advancedScales;

    final notes = _selectedScale.getNotes(_root);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Toolbar: Category Selector & Root Picker
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('Modes (7)'),
                  icon: Icon(Icons.temple_buddhist_rounded),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Advanced'),
                  icon: Icon(Icons.auto_awesome_rounded),
                ),
              ],
              selected: {_categoryTab},
              onSelectionChanged: (val) {
                setState(() {
                  _categoryTab = val.first;
                  _selectedScale = _categoryTab == 0
                      ? ScaleFormula.gregorianModes.first
                      : ScaleFormula.advancedScales.first;
                });
                widget.onScaleChanged?.call(_selectedScale);
              },
            ),
            if (widget.showRootSelector) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    value: _root,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    items: CircleOfFifthsModel.defaultKeys.map((k) {
                      return DropdownMenuItem<String>(
                        value: k.major,
                        child: Text('${k.major} Root'),
                      );
                    }).toList(),
                    onChanged: (newRoot) {
                      if (newRoot != null) {
                        setState(() {
                          _root = newRoot;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Horizontal Scales Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: scalesList.map((formula) {
              final isSelected = formula.name == _selectedScale.name;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(formula.name),
                  onSelected: (_) => _onSelectScale(formula),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Scale Detail Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_root ${_selectedScale.name}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Tap note for chord',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _selectedScale.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // Scale Notes with Degrees
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(notes.length, (index) {
                  final note = notes[index];
                  final degree = _selectedScale.degreeLabels[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ChordInspectorSheet.show(
                        context,
                        chordSymbol: note,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: index == 0
                            ? colorScheme.primaryContainer
                            : colorScheme.secondaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: index == 0
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            note,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: index == 0
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            degree,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Formula steps
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Step Formula (Semitones): ',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _selectedScale.steps.join(' - '),
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Piano Keybed View
        if (widget.showPianoKeyboard) ...[
          const SizedBox(height: 16),
          PianoKeybedWidget(
            highlightedNotes: notes,
            rootNote: _root,
            octaves: 2,
            height: 130,
            preferFlats: ChordTransposer.prefersFlatsForKey(_root),
          ),
        ],
      ],
    );
  }
}
