import 'package:flutter_test/flutter_test.dart';

import 'package:dataqube/main.dart';

void main() {
  testWidgets('shows tabs and coming soon favorites', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DataQubeApp());

    expect(find.text('List'), findsOneWidget);
    expect(find.text('Favs'), findsOneWidget);
    expect(find.text('Search users'), findsOneWidget);

    await tester.tap(find.text('Favs'));
    await tester.pumpAndSettle();

    expect(find.text('Coming soon'), findsOneWidget);
  });
}
