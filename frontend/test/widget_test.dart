import 'package:flutter_test/flutter_test.dart';
import 'package:pcpe_frontend/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const PcpeApp());
    await tester.pumpAndSettle();
  });
}
