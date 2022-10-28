import 'package:example/pond.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<void> main(List<String> args) async {
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext)
    ..register(HelloWorldAutomatePondComponent());

  await automatePondContext.load();
}

class HelloWorldAutomatePondComponent extends AutomatePondComponent {}
