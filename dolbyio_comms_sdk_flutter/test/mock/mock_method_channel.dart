import 'package:mockito/mockito.dart';

class MockMethodChannel extends Mock {
  Object? call(String name, [dynamic arguments]);
}
