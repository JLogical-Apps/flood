import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class IsEmailPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<IsEmailValueObjectProperty> {
  IsEmailPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(IsEmailValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(
    IsEmailValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField.cast<String, String>().isEmail();
  }
}
