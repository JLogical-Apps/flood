import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class ValidatorPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<ValidatorValueObjectProperty> {
  ValidatorPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(ValidatorValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(
    ValidatorValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField.withValidator(behavior.validator.forPortField());
  }
}
