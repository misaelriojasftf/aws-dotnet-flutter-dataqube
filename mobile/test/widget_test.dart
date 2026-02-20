import 'package:flutter_test/flutter_test.dart';

import 'package:dataqube/app.dart';

void main() {
  testWidgets('shows login button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Login with Cognito'), findsOneWidget);
  });
}
