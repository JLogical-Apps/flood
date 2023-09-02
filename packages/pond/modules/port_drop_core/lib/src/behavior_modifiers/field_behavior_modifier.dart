import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class FieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty> {
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  FieldBehaviorModifier({required this.modifierGetter});

  @override
  Map<String, PortField> getPortFieldByName(
    FieldValueObjectProperty behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    return {behavior.name: PortField(value: behavior.value ?? defaultValue)};
  }
}
