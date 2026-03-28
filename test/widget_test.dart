import 'package:flutter_test/flutter_test.dart';
import 'package:pistci/main.dart';

void main() {
  testWidgets('PistCI app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const PistCIApp());
    await tester.pumpAndSettle();
    expect(find.text('PistCI'), findsOneWidget);
  });
}
