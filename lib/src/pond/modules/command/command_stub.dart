import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../property/field_property.dart';
import '../../property/list_field_property.dart';
import '../../property/property.dart';
import '../../record/value_object.dart';
import 'command_parameter_stub.dart';

class CommandStub extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final displayNameProperty = FieldProperty<String>(name: 'displayName').withFallback(() => nameProperty.value);
  late final descriptionProperty = FieldProperty<String>(name: 'description');
  late final categoryProperty = FieldProperty<String>(name: 'category');
  late final parametersProperty = ListFieldProperty<CommandParameterStub>(name: 'parameters');

  @override
  List<Property> get properties =>
      super.properties +
      [
        nameProperty,
        displayNameProperty,
        descriptionProperty,
        categoryProperty,
        parametersProperty,
      ];

  static CommandStub fromCommand(Command command) {
    return CommandStub()
      ..nameProperty.value = command.name
      ..displayNameProperty.value = command.displayName
      ..descriptionProperty.value = command.description
      ..categoryProperty.value = command.category
      ..parametersProperty.value =
          command.parameters.mapToIterable((name, param) => CommandParameterStub.fromParameter(name, param)).toList();
  }
}
