import 'package:flutter_test/flutter_test.dart';
import 'package:iot_device_manager/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const IoTDeviceManagerApp());
    await tester.pumpAndSettle();

    expect(find.text('IoT Device Manager'), findsOneWidget);
  });
}