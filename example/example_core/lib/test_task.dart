import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class GreetTaskRoute with IsRoute<GreetTaskRoute> {
  late final nameProperty = field<String>(name: 'name').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('greet').property(nameProperty);

  @override
  GreetTaskRoute copy() {
    return GreetTaskRoute();
  }
}

class GreetTask with IsTask<GreetTaskRoute, String> {
  @override
  Future<String> onRun(GreetTaskRoute route) async {
    return 'Hi ${route.nameProperty.value}';
  }
}
