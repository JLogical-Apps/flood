import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

class ListFieldBehaviorModifier extends PortGeneratorBehaviorModifier<ListValueObjectProperty> {
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  ListFieldBehaviorModifier({required this.modifierGetter});

  @override
  Map<String, PortField> getPortFieldByName(
    ListValueObjectProperty behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    return {behavior.name: PortField.list(initialValues: behavior.value.nullIfEmpty ?? defaultValue)};
  }
}
