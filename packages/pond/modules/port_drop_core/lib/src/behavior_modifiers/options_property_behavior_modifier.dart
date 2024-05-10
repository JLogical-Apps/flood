import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class OptionsPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<OptionsValueObjectProperty> {
  OptionsPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(OptionsValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField? getPortField(
    OptionsValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    return PortField.option(options: behavior.options, initialValue: behavior.value ?? defaultValue);
  }
}
