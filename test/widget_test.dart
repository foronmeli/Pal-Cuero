import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pal_cuero/main.dart';

void main() {
  testWidgets('MyApp renders custom home widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MyApp(
        home: Scaffold(
          body: Center(
            child: Text('Pal Cuero test'),
          ),
        ),
      ),
    );

    expect(find.text('Pal Cuero test'), findsOneWidget);
    expect(find.text("Pal' Cuero"), findsNothing);
  });
}
