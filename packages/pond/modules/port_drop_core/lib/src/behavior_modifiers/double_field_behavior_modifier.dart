import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class DoubleFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<double?, dynamic>> {
  @override
  Map<String, PortField> getPortFieldByName(FieldValueObjectProperty<double?, dynamic> behavior) {
    return {behavior.name: PortField<double?, double?>(value: behavior.value)};
  }
}
