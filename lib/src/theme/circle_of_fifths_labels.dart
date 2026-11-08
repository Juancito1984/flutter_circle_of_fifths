/// Localization and custom text labels configuration for all widgets
/// across the `flutter_circle_of_fifths` library.
class CircleOfFifthsLabels {
  // --- CircleOfFifthsSheet & Navigation ---
  /// Title shown in the Circle of Fifths sheet header.
  final String title;

  /// Label for the interactive wheel tab/segment.
  final String interactiveWheelLabel;

  /// Label for the summary grid tab/segment.
  final String summaryViewLabel;

  // --- ScaleDetailCard ---
  /// Suffix/label for minor key relative mode (e.g., "Minor (Relative of {major})").
  final String minorLabel;

  /// Suffix/label for major key mode (e.g., "Major").
  final String majorLabel;

  /// Hint text above scale degrees (e.g., "Tap degree for chord").
  final String tapDegreeForChordHint;

  // --- ChordSheetViewer ---
  /// Label for the transposition stepper (e.g., "Transpose:").
  final String transposeLabel;

  /// Reset transposition button label (e.g., "Reset").
  final String resetLabel;

  /// Key selection label (e.g., "Key:").
  final String keyLabel;

  /// Title above the unique song chords bar (e.g., "Chords (tap to view diagram):").
  final String uniqueChordsLabel;

  // --- ChordInspectorSheet & Diagrams ---
  /// Root note label in chord inspector (e.g., "Root:").
  final String rootLabel;

  /// Bass note label when slash chord is present (e.g., "Bass:").
  final String bassLabel;

  /// Intervals formula label in chord inspector (e.g., "Intervals:").
  final String intervalsLabel;

  /// Notes chip list label (e.g., "Notes:").
  final String notesLabel;

  /// Guitar tab label in instrument selector.
  final String guitarLabel;

  /// Ukulele tab label in instrument selector.
  final String ukuleleLabel;

  /// Piano tab label in instrument selector.
  final String pianoLabel;

  /// Close button tooltip.
  final String closeTooltip;

  // --- ProgressionBuilderWidget ---
  /// Title of the progression builder widget.
  final String progressionTitle;

  /// Subtitle / description of progression builder.
  final String progressionSubtitle;

  /// Label for the passing chords / secondary dominants section.
  final String passingChordsSectionLabel;

  // --- ScaleModesWidget ---
  /// Gregorian Modes category tab label.
  final String modesCategoryLabel;

  /// Advanced scales category tab label.
  final String advancedCategoryLabel;

  /// Step formula label in mode card.
  final String stepFormulaLabel;

  /// Root dropdown item suffix (e.g., "{key} Root").
  final String rootDropdownSuffix;

  /// Creates a [CircleOfFifthsLabels] configuration.
  /// All parameters default to standard English labels.
  const CircleOfFifthsLabels({
    this.title = 'Circle of Fifths',
    this.interactiveWheelLabel = 'Interactive Wheel',
    this.summaryViewLabel = 'Summary View',
    this.minorLabel = 'Minor (Relative of',
    this.majorLabel = 'Major',
    this.tapDegreeForChordHint = 'Tap degree for chord',
    this.transposeLabel = 'Transpose:',
    this.resetLabel = 'Reset',
    this.keyLabel = 'Key:',
    this.uniqueChordsLabel = 'Chords (tap to view diagram):',
    this.rootLabel = 'Root:',
    this.bassLabel = 'Bass:',
    this.intervalsLabel = 'Intervals:',
    this.notesLabel = 'Notes:',
    this.guitarLabel = 'Guitar',
    this.ukuleleLabel = 'Ukulele',
    this.pianoLabel = 'Piano',
    this.closeTooltip = 'Close',
    this.progressionTitle = 'Harmonic Progression',
    this.progressionSubtitle = 'Roman numeral harmonic analysis',
    this.passingChordsSectionLabel =
        'Passing Chords & Secondary Dominants (Tap to add):',
    this.modesCategoryLabel = 'Modes (7)',
    this.advancedCategoryLabel = 'Advanced',
    this.stepFormulaLabel = 'Step Formula (Semitones): ',
    this.rootDropdownSuffix = 'Root',
  });

  /// Predefined Spanish labels configuration.
  static const CircleOfFifthsLabels spanish = CircleOfFifthsLabels(
    title: 'Círculo de Quintas',
    interactiveWheelLabel: 'Rueda Interactiva',
    summaryViewLabel: 'Vista Resumen',
    minorLabel: 'Menor (Relativo de',
    majorLabel: 'Mayor',
    tapDegreeForChordHint: 'Toca el grado para ver acorde',
    transposeLabel: 'Transponer:',
    resetLabel: 'Restablecer',
    keyLabel: 'Tonalidad:',
    uniqueChordsLabel: 'Acordes (toca para ver diagrama):',
    rootLabel: 'Tónica:',
    bassLabel: 'Bajo:',
    intervalsLabel: 'Intervalos:',
    notesLabel: 'Notas:',
    guitarLabel: 'Guitarra',
    ukuleleLabel: 'Ukelele',
    pianoLabel: 'Piano',
    closeTooltip: 'Cerrar',
    progressionTitle: 'Progresión Armónica',
    progressionSubtitle: 'Análisis armónico en números romanos',
    passingChordsSectionLabel:
        'Acordes de Paso y Dominantes Secundarios (Toca para agregar):',
    modesCategoryLabel: 'Modos (7)',
    advancedCategoryLabel: 'Avanzado',
    stepFormulaLabel: 'Fórmula de Pasos (Semitonos): ',
    rootDropdownSuffix: 'Tónica',
  );

  /// Creates a copy of this labels configuration with the given fields replaced with new values.
  CircleOfFifthsLabels copyWith({
    String? title,
    String? interactiveWheelLabel,
    String? summaryViewLabel,
    String? minorLabel,
    String? majorLabel,
    String? tapDegreeForChordHint,
    String? transposeLabel,
    String? resetLabel,
    String? keyLabel,
    String? uniqueChordsLabel,
    String? rootLabel,
    String? bassLabel,
    String? intervalsLabel,
    String? notesLabel,
    String? guitarLabel,
    String? ukuleleLabel,
    String? pianoLabel,
    String? closeTooltip,
    String? progressionTitle,
    String? progressionSubtitle,
    String? passingChordsSectionLabel,
    String? modesCategoryLabel,
    String? advancedCategoryLabel,
    String? stepFormulaLabel,
    String? rootDropdownSuffix,
  }) {
    return CircleOfFifthsLabels(
      title: title ?? this.title,
      interactiveWheelLabel:
          interactiveWheelLabel ?? this.interactiveWheelLabel,
      summaryViewLabel: summaryViewLabel ?? this.summaryViewLabel,
      minorLabel: minorLabel ?? this.minorLabel,
      majorLabel: majorLabel ?? this.majorLabel,
      tapDegreeForChordHint:
          tapDegreeForChordHint ?? this.tapDegreeForChordHint,
      transposeLabel: transposeLabel ?? this.transposeLabel,
      resetLabel: resetLabel ?? this.resetLabel,
      keyLabel: keyLabel ?? this.keyLabel,
      uniqueChordsLabel: uniqueChordsLabel ?? this.uniqueChordsLabel,
      rootLabel: rootLabel ?? this.rootLabel,
      bassLabel: bassLabel ?? this.bassLabel,
      intervalsLabel: intervalsLabel ?? this.intervalsLabel,
      notesLabel: notesLabel ?? this.notesLabel,
      guitarLabel: guitarLabel ?? this.guitarLabel,
      ukuleleLabel: ukuleleLabel ?? this.ukuleleLabel,
      pianoLabel: pianoLabel ?? this.pianoLabel,
      closeTooltip: closeTooltip ?? this.closeTooltip,
      progressionTitle: progressionTitle ?? this.progressionTitle,
      progressionSubtitle: progressionSubtitle ?? this.progressionSubtitle,
      passingChordsSectionLabel:
          passingChordsSectionLabel ?? this.passingChordsSectionLabel,
      modesCategoryLabel: modesCategoryLabel ?? this.modesCategoryLabel,
      advancedCategoryLabel:
          advancedCategoryLabel ?? this.advancedCategoryLabel,
      stepFormulaLabel: stepFormulaLabel ?? this.stepFormulaLabel,
      rootDropdownSuffix: rootDropdownSuffix ?? this.rootDropdownSuffix,
    );
  }
}
