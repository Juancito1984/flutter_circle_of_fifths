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

    testWidgets('CircleOfFifthsSheet displays interactive wheel and title',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleOfFifthsSheet(),
          ),
        ),
      );

      expect(find.text('Circle of Fifths'), findsOneWidget);
      expect(find.text('Interactive Wheel'), findsOneWidget);
      expect(find.text('Summary View'), findsOneWidget);
    });
  });
}
