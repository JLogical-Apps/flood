import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class StringFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<String, dynamic>> {
  @override
  Map<String, PortField> getPortFieldByName(ValueObjectBehavior behavior) {
    behavior as FieldValueObjectProperty<String, dynamic>;
    return {behavior.name: PortField.string(initialValue: behavior.value)};
  }
}
