import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dh/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app with `isLoggedIn` set to false for the test.
    await tester.pumpWidget(MyApp(isLoggedIn: false));

    // Since there is no counter or similar widget in the sample `MyApp` provided,
    // this example needs to be adapted to reflect actual widgets you want to test.
    // For demonstration purposes, let's assume you have a text widget with '0'.

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

  // Tap the '+' icon and trigger a frame.
  (WidgetTester tester) async {
  // Build the widget.
  await tester.pumpWidget(MyApp());

  // Check initial state - button is a specific color.
  expect(find.byType(IconButton), findsOneWidget);
  IconButton button = tester.widget(find.byIcon(Icons.add));
  expect(button.color, equals(Colors.grey)); // Assume initial color is grey.

  // Tap the button and pump to trigger a frame.
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();


    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
