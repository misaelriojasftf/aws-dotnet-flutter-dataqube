import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dataqube/main.dart';

void main() {
  testWidgets('adds favorite from list and shows it in favorites tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DataQubeApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Search users'), findsOneWidget);
    expect(find.text('Leanne Graham'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('toggle-favorite-1')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favs'));
    await tester.pumpAndSettle();

    expect(find.text('No favorites yet'), findsNothing);
    expect(find.text('Leanne Graham'), findsOneWidget);
  });
}
