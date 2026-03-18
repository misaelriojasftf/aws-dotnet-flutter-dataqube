import 'package:dataqube/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders home view title', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Amplify Lambda Demo'), findsOneWidget);
    expect(find.text('Call Lambda'), findsOneWidget);
  });
}
