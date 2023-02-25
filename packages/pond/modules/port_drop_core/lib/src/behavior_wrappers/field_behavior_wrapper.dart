import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';

class FieldBehaviorWrapper extends PortGeneratorBehaviorWrapper<FieldValueObjectProperty> {
  @override
  Map<String, PortValue> getPortValueByName(ValueObjectBehavior behavior) {
    behavior as FieldValueObjectProperty;
    return {behavior.name: PortValue(value: behavior.value)};
  }
}
