import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class RequiredOnEditPropertyBehaviorModifier
    extends WrapperPortGeneratorBehaviorModifier<RequiredOnEditValueObjectProperty> {
  RequiredOnEditPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(RequiredOnEditValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  bool isRequiredOnEdit(RequiredOnEditValueObjectProperty behavior) {
    return behavior.requiredOnEdit;
  }

  @override
  PortField getPortField(
    RequiredOnEditValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField.withHint(null).required();
  }
}
