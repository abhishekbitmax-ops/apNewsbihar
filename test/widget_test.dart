import 'package:flutter_test/flutter_test.dart';

import 'package:ap_news/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ApNewsApp());

    expect(find.text('FitnessHub'), findsOneWidget);
    expect(find.text('SIGN IN'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);
    expect(find.text('Continue with'), findsOneWidget);
  });
}
