import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void main() {
  testWidgets('Demo app loads Circle of Fifths homepage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Circle of Fifths'), findsWidgets);
    expect(find.byType(CircleOfFifthsWheelWidget), findsOneWidget);
    expect(find.byType(ScaleDetailCard), findsOneWidget);
  });
}
