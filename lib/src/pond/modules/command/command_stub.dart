import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/command/command.dart';

class CommandStub extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final parametersProperty = MapFieldProperty<String, CommandParameterStub>(name: 'parameters');

  @override
  List<Property> get properties => super.properties + [nameProperty, parametersProperty];

  static CommandStub fromCommand(Command command) {
    return CommandStub()
      ..nameProperty.value = command.name
      ..parametersProperty.value =
          command.parameters.map((name, param) => MapEntry(name, CommandParameterStub.fromParameter(param)));
  }
}
