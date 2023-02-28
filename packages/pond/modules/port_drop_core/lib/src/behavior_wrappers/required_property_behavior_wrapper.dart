import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';

class RequiredPropertyBehaviorWrapper extends WrapperPortGeneratorBehaviorWrapper<RequiredValueObjectProperty> {
  RequiredPropertyBehaviorWrapper({required super.wrapperGetter});

  @override
  ValueObjectBehavior unwrapBehavior(RequiredValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortValue getPortValue(PortValue sourcePortValue) {
    return sourcePortValue.isNotNull();
  }
}
