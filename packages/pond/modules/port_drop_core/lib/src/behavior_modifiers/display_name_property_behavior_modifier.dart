import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class DisplayNamePropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<DisplayNameValueObjectProperty> {
  DisplayNamePropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(DisplayNameValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(DisplayNameValueObjectProperty behavior, PortField sourcePortField) {
    return sourcePortField.withDynamicDisplayName(behavior.displayNameGetter);
  }
}
