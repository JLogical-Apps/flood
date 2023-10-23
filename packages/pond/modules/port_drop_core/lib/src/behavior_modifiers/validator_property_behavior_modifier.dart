import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

class ValidatorPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<ValidatorValueObjectProperty> {
  ValidatorPropertyBehaviorModifier({required super.modifierGetter});

  @override
  PortField getPortField(
    ValidatorValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField.withValidator(Validator((data) async {
      try {
        return await behavior.validator.forPortField().validate(data);
      } catch (e) {
        return 'Invalid';
      }
    }));
  }

  @override
  ValueObjectBehavior unwrapBehavior(ValidatorValueObjectProperty behavior) {
    return behavior.property;
  }
}
