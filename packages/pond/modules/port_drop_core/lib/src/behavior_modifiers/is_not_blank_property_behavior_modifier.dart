import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class IsNotBlankPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<IsNotBlankValueObjectProperty> {
  @override
  PortField getPortField(
    IsNotBlankValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField.cast<String, String>().isNotBlank();
  }
}
