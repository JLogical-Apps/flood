import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

class PlaceholderPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<PlaceholderValueObjectProperty> {
  PlaceholderPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(PlaceholderValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(
    PlaceholderValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField.withDynamicHint(() => guard(() => behavior.placeholder()));
  }
}
