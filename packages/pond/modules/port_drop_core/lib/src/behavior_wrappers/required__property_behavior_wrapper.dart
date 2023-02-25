import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';

class RequiredPropertyBehaviorWrapper extends PortGeneratorBehaviorWrapper<RequiredValueObjectProperty> {
  final PortGeneratorBehaviorWrapper? Function(ValueObjectBehavior behavior) wrapperGetter;

  RequiredPropertyBehaviorWrapper({required this.wrapperGetter});

  @override
  Map<String, PortValue> getPortValueByName(ValueObjectBehavior behavior) {
    behavior as RequiredValueObjectProperty;

    final subWrapper = wrapperGetter(behavior.property);
    if (subWrapper == null) {
      return {};
    }

    final subPortValueByName = subWrapper.getPortValueByName(behavior.property);
    return subPortValueByName.map((name, portValue) => MapEntry(name, portValue.isNotNull()));
  }
}
