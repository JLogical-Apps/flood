import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class DateTimeFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<DateTime?>> {
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  DateTimeFieldBehaviorModifier({required this.modifierGetter});

  @override
  Map<String, PortField> getPortFieldByName(
    FieldValueObjectProperty<DateTime?> behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    final onlyDate = modifierGetter(context.originalBehavior)?.isOnlyDate(context.originalBehavior) ?? false;
    return {
      behavior.name: PortField.dateTime(
        initialValue: behavior.value ?? defaultValue,
        isTime: !onlyDate,
      )
    };
  }
}
