import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class DoubleFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<double?>> {
  @override
  Map<String, PortField> getPortFieldByName(
    FieldValueObjectProperty<double?> behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue =
        BehaviorMetaModifier.getModifier(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    return {behavior.name: PortField.double(initialValue: behavior.value ?? defaultValue)};
  }
}
