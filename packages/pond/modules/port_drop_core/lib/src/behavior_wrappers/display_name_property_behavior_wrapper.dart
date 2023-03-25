import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';

class DisplayNamePropertyBehaviorWrapper extends WrapperPortGeneratorBehaviorWrapper<DisplayNameValueObjectProperty> {
  DisplayNamePropertyBehaviorWrapper({required super.wrapperGetter});

  @override
  ValueObjectBehavior unwrapBehavior(DisplayNameValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(DisplayNameValueObjectProperty behavior, PortField sourcePortField) {
    return sourcePortField.withDynamicDisplayName(behavior.displayNameGetter);
  }
}
