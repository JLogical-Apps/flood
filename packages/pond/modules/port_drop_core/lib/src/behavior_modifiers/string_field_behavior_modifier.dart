import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class StringFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<String?>> {
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  StringFieldBehaviorModifier({required this.modifierGetter});

  @override
  Map<String, PortField> getPortFieldByName(
    FieldValueObjectProperty<String?> behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    return {behavior.name: PortField.string(initialValue: behavior.value ?? defaultValue)};
  }
}
