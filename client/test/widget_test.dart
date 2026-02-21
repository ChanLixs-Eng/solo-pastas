import 'package:flutter_test/flutter_test.dart';
import 'package:solo_pastas/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SoloPastasApp());
    expect(find.text('Solo Pastas'), findsOneWidget);
  });
}
