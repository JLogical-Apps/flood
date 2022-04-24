import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/command_parameter.dart';
import 'package:jlogical_utils/src/patterns/command/parameter/required_parameter.dart';

class CommandParameterStub extends ValueObject {
  late final typeProperty = FieldProperty<String>(name: 'type').required();
  late final requiredProperty = FieldProperty<bool>(name: 'required').withFallback(() => false);

  @override
  List<Property> get properties => super.properties + [typeProperty, requiredProperty];

  static CommandParameterStub fromParameter(CommandParameter param) {
    return CommandParameterStub()
      ..typeProperty.value = param.type
      ..requiredProperty.value = param is RequiredParameter;
  }
}
