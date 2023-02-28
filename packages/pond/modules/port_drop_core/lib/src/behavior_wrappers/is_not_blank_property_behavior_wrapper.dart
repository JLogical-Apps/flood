import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';
import 'package:utils_core/utils_core.dart';

class IsNotBlankPropertyBehaviorWrapper extends WrapperPortGeneratorBehaviorWrapper<IsNotBlankValueObjectProperty> {
  IsNotBlankPropertyBehaviorWrapper({required super.wrapperGetter});

  @override
  ValueObjectBehavior unwrapBehavior(IsNotBlankValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortValue getPortValue(PortValue sourcePortValue) {
    return sourcePortValue.as<SimplePortValue<String>>()?.isNotBlank() ?? sourcePortValue;
  }
}
