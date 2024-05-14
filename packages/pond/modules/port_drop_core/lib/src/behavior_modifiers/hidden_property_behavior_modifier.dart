import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class HiddenPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<HiddenValueObjectProperty> {
  @override
  PortField? getPortField(
    HiddenValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return behavior.isHidden ? null : sourcePortField;
  }
}
