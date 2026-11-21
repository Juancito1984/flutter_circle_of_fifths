import 'package:material_ui/material_ui.dart';
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
      expect(ChordTransposer.transposeChord('C', 5, targetKey: 'F'), 'F');
      expect(ChordTransposer.transposeChord('F', 5, targetKey: 'Bb'), 'Bb');
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
      expect(String.fromCharCodes(wavSingle.sublist(0, 4)), 'RIFF');
      expect(String.fromCharCodes(wavSingle.sublist(8, 12)), 'WAVE');

      final wavChord = SimpleAudioSynthesizer.synthesizeChordNotes([
        'C',
        'E',
        'G',
      ], durationSeconds: 0.1);
      expect(wavChord.length, greaterThan(44));
    });
  });

  group('Widget Tests', () {
    testWidgets('CircleOfFifthsWheelWidget renders without errors', (
      tester,
    ) async {
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

      // Tap near top (12:00) where C Major is located
      int tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: CircleOfFifthsWheelWidget(
                  selectedIndex: 0,
                  isMinorMode: false,
                  onKeySelected: (index, isMinor) {
                    tapCount++;
                    expect(index, 0);
                    expect(isMinor, false);
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Tap at the outer major ring at 12:00 (x: 150, y: 25)
      await tester.tapAt(
        tester.getCenter(find.byType(CircleOfFifthsWheelWidget)) -
            const Offset(0, 125),
      );
      await tester.pump();
      expect(tapCount, 1);
    });

    testWidgets('ScaleDetailCard renders scale details for C Major', (
      tester,
    ) async {
      final cMajor = CircleOfFifthsModel.defaultKeys[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScaleDetailCard(model: cMajor, isMinorMode: false),
          ),
        ),
      );

      expect(find.text('C Major'), findsOneWidget);
      expect(find.byType(ScaleDetailCard), findsOneWidget);
    });

    testWidgets(
      'CircleOfFifthsSheet displays interactive wheel, title and custom labels',
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
      },
    );

    testWidgets(
      'ChordSheetViewer renders lyrics, chords, and transposes on tap',
      (tester) async {
        const songText = '''
[C]Amazing [F]grace, how [C]sweet the sound
That [C]saved a [G7]wretch like [C]me
''';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ChordSheetViewer(songText: songText, originalKey: 'C'),
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
      },
    );

    testWidgets(
      'ChordSheetViewer hides chords and toolbar when showChords is false',
      (tester) async {
        const songText = '''
[C]Amazing [F]grace, how [C]sweet the sound
That [C]saved a [G7]wretch like [C]me
''';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ChordSheetViewer(songText: songText, showChords: false),
              ),
            ),
          ),
        );

        expect(find.byType(ChordSheetViewer), findsOneWidget);
        expect(find.text('Amazing grace, how sweet the sound'), findsOneWidget);
        expect(find.text('G7'), findsNothing);
        expect(find.text('C'), findsNothing);
        expect(find.byTooltip('+1 Semitone'), findsNothing);
      },
    );

    testWidgets(
      'ProgressionBuilderWidget and ScaleModesWidget render cleanly',
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
      },
    );

    test('ChordSheetDocument parses [D][/][F#m] and [D/F#m] equivalently and preserves [D/F#]', () {
      final docFormat1 = ChordSheetDocument.parse(
        '[D][/][F#m]Amazing [D/F#]grace',
        transposeSemitones: 2,
      );
      final docFormat2 = ChordSheetDocument.parse(
        '[D/F#m]Amazing [D/F#]grace',
        transposeSemitones: 2,
      );

      expect(docFormat1.uniqueChords, ['E', 'G#m', 'E/G#']);
      expect(docFormat2.uniqueChords, ['E', 'G#m', 'E/G#']);

      final seg1 = docFormat1.lines.first.segments.first;
      final seg2 = docFormat2.lines.first.segments.first;

      expect(seg1.chord, 'E/G#m');
      expect(seg1.chords, ['E', 'G#m']);
      expect(seg1.lyric, 'Amazing ');

      expect(seg2.chord, 'E/G#m');
      expect(seg2.chords, ['E', 'G#m']);
      expect(seg2.lyric, 'Amazing ');

      final slashBassSeg = docFormat2.lines.first.segments[1];
      expect(slashBassSeg.chord, 'E/G#');
      expect(slashBassSeg.chords, ['E/G#']);
      expect(slashBassSeg.lyric, 'grace');

      expect(
        ChordTransposer.transposeLyrics('[D][/][F#m]Amazing [D/F#m]grace', 2),
        '[E][/][G#m]Amazing [E/G#m]grace',
      );
    });

    testWidgets(
      'ChordSheetViewer renders [D][/][F#m] and [D/F#m] as D/F#m, transposes both, and inspects each chord',
      (tester) async {
        final tappedChords = <String>[];
        const songText = '[D][/][F#m]Amazing [D/F#m]grace';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ChordSheetViewer(
                  songText: songText,
                  originalKey: 'D',
                  showChordSummaryBar: false,
                  showDiagramModalOnTap: false,
                  onTapChord: (info) => tappedChords.add(info.symbol),
                ),
              ),
            ),
          ),
        );

        expect(find.text('[/]'), findsNothing);
        expect(find.text('D'), findsNWidgets(2));
        expect(find.text('F#m'), findsNWidgets(2));

        await tester.tap(find.text('D').first);
        await tester.tap(find.text('F#m').first);
        expect(tappedChords, ['D', 'F#m']);

        await tester.tap(find.byTooltip('+1 Semitone'));
        await tester.pumpAndSettle();

        expect(find.text('D#'), findsNWidgets(2));
        expect(find.text('Gm'), findsNWidgets(2));

        await tester.tap(find.byTooltip('+1 Semitone'));
        await tester.pumpAndSettle();

        expect(find.text('E'), findsNWidgets(2));
        expect(find.text('G#m'), findsNWidgets(2));
      },
    );

    test(
      'ChordSheetDocument and transposeLyrics support [Bm/][A] and [Bm][/A]',
      () {
        final docTrailing = ChordSheetDocument.parse(
          '[Bm/][A]Amazing',
          transposeSemitones: 2,
        );
        final docLeading = ChordSheetDocument.parse(
          '[Bm][/A]Amazing',
          transposeSemitones: 2,
        );

        expect(docTrailing.uniqueChords, ['C#m', 'B']);
        expect(docLeading.uniqueChords, ['C#m', 'B']);

        final segTrailing = docTrailing.lines.first.segments.first;
        final segLeading = docLeading.lines.first.segments.first;

        expect(segTrailing.chord, 'C#m/B');
        expect(segTrailing.chords, ['C#m', 'B']);
        expect(segTrailing.lyric, 'Amazing');

        expect(segLeading.chord, 'C#m/B');
        expect(segLeading.chords, ['C#m', 'B']);
        expect(segLeading.lyric, 'Amazing');

        expect(
          ChordTransposer.transposeLyrics('[Bm/][A]Amazing [Bm][/A]grace', 2),
          '[C#m/][B]Amazing [C#m][/B]grace',
        );
      },
    );

    testWidgets(
      'ChordSheetViewer renders [Bm/][A] and [Bm][/A] as Bm/A and transposes both',
      (tester) async {
        final tappedChords = <String>[];
        const songText = '[Bm/][A]Amazing [Bm][/A]grace';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ChordSheetViewer(
                  songText: songText,
                  originalKey: 'D',
                  showChordSummaryBar: false,
                  showDiagramModalOnTap: false,
                  onTapChord: (info) => tappedChords.add(info.symbol),
                ),
              ),
            ),
          ),
        );

        expect(find.text('[Bm/]'), findsNothing);
        expect(find.text('[/A]'), findsNothing);
        expect(find.text('Bm'), findsNWidgets(2));
        expect(find.text('A'), findsNWidgets(2));

        await tester.tap(find.text('Bm').first);
        await tester.tap(find.text('A').first);
        expect(tappedChords, ['Bm', 'A']);

        await tester.tap(find.byTooltip('+1 Semitone'));
        await tester.pumpAndSettle();

        expect(find.text('Cm'), findsNWidgets(2));
        expect(find.text('A#'), findsNWidgets(2));
      },
    );

    test('ChordSheetDocument parses braced chord-over-lyric lines aligned by column and distinguishes slash-bass chords', () {
      const song = '''
{  Dm             F#m      C}
Yo se que estás aquí mi señor
{   A             Dm} 
Yo se que estas aquí

{    Dm/A                F#m       C}
Yo se que estás aquí mi señor

[Intro]
{  Dm    F#m    C}
''';

      final doc = ChordSheetDocument.parse(song);
      expect(doc.uniqueChords, ['Dm', 'F#m', 'C', 'A', 'Dm/A']);

      // Line 0: {  Dm             F#m      C} + Yo se que estás aquí mi señor
      final line0 = doc.lines[0];
      expect(line0.type, ChordSheetLineType.chordLyrics);
      expect(
        line0.segments.map((s) => s.lyric).join(),
        'Yo se que estás aquí mi señor',
      );
      final dmSeg = line0.segments.firstWhere((s) => s.chord == 'Dm');
      final fSharpMSeg = line0.segments.firstWhere((s) => s.chord == 'F#m');
      final cSeg = line0.segments.firstWhere((s) => s.chord == 'C');
      expect(dmSeg.lyric, 'se ');
      expect(fSharpMSeg.lyric, 'uí ');
      expect(cSeg.lyric, 'or');

      // Line 1: {   A             Dm}  + Yo se que estas aquí
      final line1 = doc.lines[1];
      expect(line1.segments.map((s) => s.lyric).join(), 'Yo se que estas aquí');
      final aSeg = line1.segments.firstWhere((s) => s.chord == 'A');
      final dm2Seg = line1.segments.firstWhere((s) => s.chord == 'Dm');
      expect(aSeg.lyric, 'e ');
      expect(dm2Seg.lyric, 'uí');

      // Line 3: {    Dm/A                F#m       C} + Yo se que estás aquí mi señor
      // In auto mode, proportional width maps Dm/A -> se, F#m -> quí, C -> ñor
      final line3 = doc.lines[3];
      final slashBassSeg = line3.segments.firstWhere((s) => s.chord == 'Dm/A');
      expect(slashBassSeg.chords, ['Dm/A']);
      expect(slashBassSeg.lyric, 'se ');
      final fSharpM3Seg = line3.segments.firstWhere((s) => s.chord == 'F#m');
      expect(fSharpM3Seg.lyric, contains('uí'));
      final c3Seg = line3.segments.firstWhere((s) => s.chord == 'C');
      expect(c3Seg.lyric, contains('or'));

      // Explicit characterColumn mode preserves raw character column mapping
      final charColDoc = ChordSheetDocument.parse(
        '{    Dm/A                F#m       C}\nYo se que estás aquí mi señor',
        chordLineAlignment: ChordLineAlignment.characterColumn,
      );
      final charColTrailingC = charColDoc.lines.first.segments.firstWhere(
        (s) => s.chord == 'C',
      );
      expect(charColTrailingC.lyric, '');

      // Proportional TextField alignment (wide spaces + narrow proportional chars)
      final propDoc = ChordSheetDocument.parse(
        '{        Dm                    F#m         C}\n// Yo sé que estas aqui mi señor',
      );
      final propLine = propDoc.lines.first;
      expect(propLine.segments.firstWhere((s) => s.chord == 'Dm').lyric, 'sé ');
      expect(
        propLine.segments.firstWhere((s) => s.chord == 'F#m').lyric,
        contains('ui'),
      );
      expect(
        propLine.segments.firstWhere((s) => s.chord == 'C').lyric,
        contains('or'),
      );

      // Standalone instrumental braced chord line
      final introChordsLine = doc.lines[6];
      expect(introChordsLine.type, ChordSheetLineType.chordLyrics);
      expect(introChordsLine.segments.map((s) => s.chord).toList(), [
        'Dm',
        'F#m',
        'C',
      ]);
      expect(introChordsLine.segments.every((s) => s.lyric.isEmpty), isTrue);

      // Transposition +2 semitones preserves Dm/A as a single slash-bass chord
      final transposedDoc = ChordSheetDocument.parse(
        '{    Dm/A                F#m       C}\nYo se que estás aquí mi señor',
        transposeSemitones: 2,
      );
      expect(transposedDoc.uniqueChords, ['Em/B', 'G#m', 'D']);

      expect(
        ChordTransposer.transposeLyrics(
          '{  Dm             F#m      C}\nYo se que estás aquí mi señor',
          2,
        ),
        '{  Em             G#m      D}\nYo se que estás aquí mi señor',
      );
    });

    testWidgets(
      'ChordSheetViewer renders braced chord lines above exact lyric matches, aligns trailing chords on top row, handles Dm/A slash bass, and hides chord-only lines when showChords is false',
      (tester) async {
        ChordInfo? tappedChord;
        const songText = '''
[Intro]
{  Dm    F#m    C}

{    Dm/A                F#m       C}
Yo se que estás aquí mi señor
''';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ChordSheetViewer(
                  songText: songText,
                  originalKey: 'D',
                  showChordSummaryBar: false,
                  showDiagramModalOnTap: false,
                  onTapChord: (info) => tappedChord = info,
                ),
              ),
            ),
          ),
        );

        expect(find.text('Dm/A'), findsOneWidget);
        expect(find.text('F#m'), findsNWidgets(2));
        expect(find.text('C'), findsNWidgets(2));
        expect(find.text('{  Dm    F#m    C}'), findsNothing);

        // Trailing 'C' in lyric line must sit at the same vertical Y as 'Dm/A' and 'F#m'
        final dmAY = tester.getTopLeft(find.text('Dm/A')).dy;
        final trailingCY = tester.getTopLeft(find.text('C').last).dy;
        expect((trailingCY - dmAY).abs(), lessThan(2.0));

        // Tapping Dm/A passes root=D, quality=m, bassNote=A
        await tester.tap(find.text('Dm/A'));
        expect(tappedChord?.symbol, 'Dm/A');
        expect(tappedChord?.root, 'D');
        expect(tappedChord?.quality, 'm');
        expect(tappedChord?.bassNote, 'A');

        // Transpose +2 semitones: Dm/A -> Em/B, F#m -> G#m, C -> D
        await tester.tap(find.byTooltip('+1 Semitone'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('+1 Semitone'));
        await tester.pumpAndSettle();

        expect(find.text('Em/B'), findsOneWidget);
        expect(find.text('G#m'), findsNWidgets(2));
        expect(find.text('D'), findsNWidgets(2));

        // Verify showChords: false hides chord-only lines and renders clean lyrics
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ChordSheetViewer(songText: songText, showChords: false),
              ),
            ),
          ),
        );

        expect(find.text('Dm/A'), findsNothing);
        expect(find.text('Yo se que estás aquí mi señor'), findsOneWidget);
      },
    );

    testWidgets(
      'ChordSheetViewer keeps natural continuous word spacing when chords do not collide, separates colliding chords, and wraps long lines cleanly',
      (tester) async {
        const songText = '''
// Yo [Dm]sé que estas a[F]quí mi señ[C]or
[C]a[G]b
Esta es una línea larga que se envuelve [Dm]cuando el ancho de pantalla es [G]pequeño
''';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  width: 640,
                  child: ChordSheetViewer(
                    songText: songText,
                    showTranspositionBar: false,
                    showChordSummaryBar: false,
                  ),
                ),
              ),
            ),
          ),
        );

        // Non-colliding lyric line renders as continuous natural text without extra word gaps
        expect(
          find.text('// Yo sé que estas aquí mi señor', findRichText: true),
          findsOneWidget,
        );

        // Adjacent colliding chords [C]a[G]b are separated horizontally without overlapping
        final cRight = tester.getTopRight(find.text('C').at(1)).dx;
        final gLeft = tester.getTopLeft(find.text('G').first).dx;
        expect(gLeft, greaterThan(cRight));

        // Narrow width wraps long lines cleanly with chords still aligned
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  width: 240,
                  child: ChordSheetViewer(
                    songText: songText,
                    showTranspositionBar: false,
                    showChordSummaryBar: false,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Dm'), findsNWidgets(2));
        expect(find.text('G'), findsNWidgets(2));
      },
    );

    testWidgets(
      'ScaleDetailCard opens ChordInspectorSheet with configured defaultInstrument',
      (tester) async {
        final cMajor = CircleOfFifthsModel.defaultKeys[0];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScaleDetailCard(
                model: cMajor,
                defaultInstrument: InstrumentType.piano,
              ),
            ),
          ),
        );

        // Tap the first degree ('C') to open ChordInspectorSheet
        await tester.tap(find.text('C').first);
        await tester.pumpAndSettle();

        expect(find.byType(ChordInspectorSheet), findsOneWidget);
        expect(find.byType(PianoKeybedWidget), findsOneWidget);
      },
    );
  });
}
