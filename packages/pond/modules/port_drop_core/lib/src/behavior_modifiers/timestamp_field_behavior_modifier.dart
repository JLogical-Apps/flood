import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class TimestampFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<Timestamp?>> {
  @override
  Map<String, PortField> getPortFieldByName(
    FieldValueObjectProperty<Timestamp?> behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    var defaultValue =
        BehaviorMetaModifier.getModifier(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    if (defaultValue is Timestamp) {
      defaultValue = defaultValue.time;
    }

    final onlyDate =
        BehaviorMetaModifier.getModifier(context.originalBehavior)?.isOnlyDate(context.originalBehavior) ?? false;
    return {
      behavior.name: PortField.dateTime(
        initialValue: behavior.value?.time ?? defaultValue,
        isTime: !onlyDate,
      )
    };
  }
}
