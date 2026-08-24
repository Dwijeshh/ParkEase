import 'package:flutter_test/flutter_test.dart';

import 'package:parkease/main.dart';

void main() {
  testWidgets('Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ParkEaseApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });
}
