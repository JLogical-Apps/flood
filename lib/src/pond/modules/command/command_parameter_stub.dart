import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/required_parameter.dart';

class CommandParameterStub extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final displayNameProperty = FieldProperty<String>(name: 'displayName').withFallback(() => nameProperty.value!);
  late final descriptionProperty = FieldProperty<String>(name: 'description');
  late final typeProperty = FieldProperty<String>(name: 'type').required();
  late final requiredProperty = FieldProperty<bool>(name: 'required').withFallback(() => false);

  @override
  List<Property> get properties =>
      super.properties +
      [
        nameProperty,
        displayNameProperty,
        descriptionProperty,
        typeProperty,
        requiredProperty,
      ];

  static CommandParameterStub fromParameter(String name, CommandParameter param) {
    return CommandParameterStub()
      ..nameProperty.value = name
      ..displayNameProperty.value = param.displayName
      ..descriptionProperty.value = param.description
      ..typeProperty.value = param.type
      ..requiredProperty.value = param is RequiredParameter;
  }
}
