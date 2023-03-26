import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class FieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty> {
  @override
  Map<String, PortField> getPortFieldByName(FieldValueObjectProperty behavior) {
    return {behavior.name: PortField(value: behavior.value)};
  }
}
