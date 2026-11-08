import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void main() {
  group('CircleOfFifthsModel Tests', () {
    test('defaultKeys contains 12 musical keys', () {
      expect(CircleOfFifthsModel.defaultKeys.length, 12);
    });

    test('C Major key properties are correct', () {
      final cMajor = CircleOfFifthsModel.defaultKeys.firstWhere(
        (key) => key.major == 'C',
      );
      expect(cMajor.minor, 'a');
      expect(cMajor.subdominant, 'F');
      expect(cMajor.dominant, 'G');
      expect(cMajor.keySignature, '0#');
      expect(cMajor.secondaryChords, ['Dm', 'Em']);
      expect(cMajor.majorScaleNotes, ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C']);
      expect(cMajor.minorScaleNotes, ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'A']);
    });
  });

  group('Module 1: ChordTransposer & ChordSheetDocument Tests', () {
    test('transposes simple, extended, and slash chords accurately', () {
      expect(ChordTransposer.transposeChord('C', 2), 'D');
      expect(ChordTransposer.transposeChord('G7', 2), 'A7');
      expect(ChordTransposer.transposeChord('C/G', 2), 'D/A');
      expect(
        ChordTransposer.transposeChord('C', 5, targetKey: 'F'),
        'F',
      );
      expect(
        ChordTransposer.transposeChord('F', 5, targetKey: 'Bb'),
        'Bb',
      );
    });

    test('calculates semitones between Circle of Fifths keys', () {
      expect(ChordTransposer.semitonesBetweenKeys('C', 'G'), -5);
      expect(ChordTransposer.semitonesBetweenKeys('C', 'D'), 2);
      expect(ChordTransposer.semitonesBetweenKeys('C', 'F'), 5);
    });

    test('parses ChordPro song text and transposes chords', () {
      const song = '''
{title: Amazing Grace}
[Verse 1]
[C]Amazing [F]grace, how [C]sweet the sound
That [C]saved a [G7]wretch like [C]me
''';

      final doc = ChordSheetDocument.parse(song, transposeSemitones: 2);
      expect(doc.title, 'Amazing Grace');
      expect(doc.uniqueChords, containsAll(['D', 'G', 'A7']));
    });

    test('parses ChordInfo notes and intervals accurately', () {
      final g7 = ChordTransposer.parseChord('G7');
      expect(g7.root, 'G');
      expect(g7.quality, '7');
      expect(g7.notes, ['G', 'B', 'D', 'F']);
      expect(g7.guitarVoicing.frets.length, 6);
      expect(g7.ukuleleVoicing.frets.length, 4);
    });
  });

  group('Module 3: Harmonic Progression & Roman Numeral Tests', () {
    test('computes progression chords for standard templates', () {
      final popTemplate = HarmonicProgression.standardTemplates.first;
      final cChords = popTemplate.getChordsForKey('C');
      expect(cChords, ['C', 'G', 'Am', 'F']);

      final gChords = popTemplate.getChordsForKey('G');
      expect(gChords, ['G', 'D', 'Em', 'C']);
    });

    test('analyzes Roman numerals correctly in C Major', () {
      expect(HarmonicProgression.analyzeChordRoman('C', 'C'), 'I');
      expect(HarmonicProgression.analyzeChordRoman('Dm', 'C'), 'ii');
      expect(HarmonicProgression.analyzeChordRoman('G7', 'C'), 'V7');
      expect(HarmonicProgression.analyzeChordRoman('Fmaj7', 'C'), 'IVmaj7');
      expect(HarmonicProgression.analyzeChordRoman('Bdim', 'C'), 'viio');
    });

    test('provides secondary dominant suggestions', () {
      final suggestions = HarmonicProgression.getPassingChordSuggestions('C');
      expect(suggestions.isNotEmpty, true);
      expect(suggestions.any((s) => s.romanNumeral == 'V7/V'), true);
    });
  });

  group('Module 4: Scale Formulas & Gregorian Modes Tests', () {
    test('contains 7 Gregorian Modes and standard advanced scales', () {
      expect(ScaleFormula.gregorianModes.length, 7);
      expect(ScaleFormula.advancedScales.length, 5);
    });

    test('generates D Dorian notes correctly', () {
      final dorian = ScaleFormula.gregorianModes.firstWhere(
        (m) => m.name == 'Dorian',
      );
      final dDorian = dorian.getNotes('D');
      expect(dDorian, ['D', 'E', 'F', 'G', 'A', 'B', 'C']);
    });

    test('generates A Minor Pentatonic and Blues scale correctly', () {
      final blues = ScaleFormula.advancedScales.firstWhere(
        (s) => s.name == 'Blues Scale',
      );
      final aBlues = blues.getNotes('A');
      expect(aBlues, ['A', 'C', 'D', 'D#', 'E', 'G']);
    });
  });

  group('Module 5: Audio Synthesizer Tests', () {
    test('synthesizes non-empty WAV byte buffer for single note and chord', () {
      final wavSingle = SimpleAudioSynthesizer.synthesizeWav(
        frequencies: [440.0],
        durationSeconds: 0.1,
      );
      expect(wavSingle.length, greaterThan(44));
      // Check RIFF header
      expect(
        String.fromCharCodes(wavSingle.sublist(0, 4)),
        'RIFF',
      );
      expect(
        String.fromCharCodes(wavSingle.sublist(8, 12)),
        'WAVE',
      );

      final wavChord = SimpleAudioSynthesizer.synthesizeChordNotes(
        ['C', 'E', 'G'],
        durationSeconds: 0.1,
      );
      expect(wavChord.length, greaterThan(44));
    });
  });

  group('Widget Tests', () {
    testWidgets('CircleOfFifthsWheelWidget renders without errors',
        (tester) async {
      int selectedIndex = 0;
      bool isMinorMode = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleOfFifthsWheelWidget(
              selectedIndex: selectedIndex,
              isMinorMode: isMinorMode,
              onKeySelected: (index, isMinor) {
                selectedIndex = index;
                isMinorMode = isMinor;
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircleOfFifthsWheelWidget), findsOneWidget);
    });

    testWidgets('ScaleDetailCard renders scale details for C Major',
        (tester) async {
      final cMajor = CircleOfFifthsModel.defaultKeys[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScaleDetailCard(
              model: cMajor,
              isMinorMode: false,
            ),
          ),
        ),
      );

      expect(find.text('C Major'), findsOneWidget);
      expect(find.byType(ScaleDetailCard), findsOneWidget);
    });

    testWidgets('CircleOfFifthsSheet displays interactive wheel, title and custom labels',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleOfFifthsSheet(
              title: 'Círculo de Quintas',
              interactiveWheelLabel: 'Rueda Interactiva',
              summaryViewLabel: 'Vista Resumen',
            ),
          ),
        ),
      );

      expect(find.text('Círculo de Quintas'), findsOneWidget);
      expect(find.text('Rueda Interactiva'), findsOneWidget);
      expect(find.text('Vista Resumen'), findsOneWidget);
    });

    testWidgets('ChordSheetViewer renders lyrics, chords, and transposes on tap',
        (tester) async {
      const songText = '''
[C]Amazing [F]grace, how [C]sweet the sound
That [C]saved a [G7]wretch like [C]me
''';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ChordSheetViewer(
                songText: songText,
                originalKey: 'C',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ChordSheetViewer), findsOneWidget);
      expect(find.text('G7'), findsWidgets);

      // Tap +1 semitone button
      await tester.tap(find.byTooltip('+1 Semitone'));
      await tester.pumpAndSettle();

      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets('ChordSheetViewer hides chords and toolbar when showChords is false',
        (tester) async {
      const songText = '''
[C]Amazing [F]grace, how [C]sweet the sound
That [C]saved a [G7]wretch like [C]me
''';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ChordSheetViewer(
                songText: songText,
                showChords: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ChordSheetViewer), findsOneWidget);
      expect(find.text('Amazing grace, how sweet the sound'), findsOneWidget);
      expect(find.text('G7'), findsNothing);
      expect(find.text('C'), findsNothing);
      expect(find.byTooltip('+1 Semitone'), findsNothing);
    });

    testWidgets('ProgressionBuilderWidget and ScaleModesWidget render cleanly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ProgressionBuilderWidget(
                    activeKey: 'C',
                    labels: CircleOfFifthsLabels.spanish,
                  ),
                  ScaleModesWidget(
                    rootNote: 'C',
                    labels: CircleOfFifthsLabels.spanish,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ProgressionBuilderWidget), findsOneWidget);
      expect(find.byType(ScaleModesWidget), findsOneWidget);
      expect(find.text('Progresión Armónica'), findsOneWidget);
      expect(find.text('Modos (7)'), findsOneWidget);
    });
  });
}
