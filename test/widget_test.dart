import 'package:flutter_test/flutter_test.dart';
import 'package:grantha_sudha/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const GranthaSudhaApp());
    expect(find.textContaining('ಗ್ರಂಥ'), findsWidgets);
  });
}
