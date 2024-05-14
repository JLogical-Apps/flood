import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class ColorPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<ColorValueObjectProperty> {
  @override
  PortField getPortField(
    ColorValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField.cast<int?, int?>().color(behavior.isColor);
  }
}
