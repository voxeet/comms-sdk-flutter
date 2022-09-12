import 'package:dolbyio_comms_sdk_flutter_example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  setUp(() async { });

  testWidgets('Start app', (tester) async { 
    await tester.pumpWidget(const MyApp());
  });
}
