import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class TestTaskRoute with IsRoute<TestTaskRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('test');

  @override
  TestTaskRoute copy() {
    return TestTaskRoute();
  }
}

class TestTask with IsTask<TestTaskRoute, String> {
  @override
  Future<String> onRun(TestTaskRoute route) async {
    return 'Hello World!';
  }
}
