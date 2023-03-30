import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class IntFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<int?, dynamic>> {
  @override
  Map<String, PortField> getPortFieldByName(FieldValueObjectProperty<int?, dynamic> behavior) {
    return {behavior.name: PortField<int?, int?>(value: behavior.value)};
  }
}
