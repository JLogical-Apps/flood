import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';

class StringFieldBehaviorWrapper extends PortGeneratorBehaviorWrapper<FieldValueObjectProperty<String, dynamic>> {
  @override
  Map<String, PortValue> getPortValueByName(ValueObjectBehavior behavior) {
    behavior as FieldValueObjectProperty<String, dynamic>;
    return {behavior.name: PortValue.string(initialValue: behavior.value)};
  }
}
