import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

abstract class PortGeneratorBehaviorModifier<T extends ValueObjectBehavior>
    with IsTypedModifier<T, ValueObjectBehavior> {
  Map<String, PortField> getPortFieldByName(T behavior, PortGeneratorBehaviorModifierContext context);

  PortField? getPortField(
    T behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField;
  }

  dynamic getHintOrNull(T behavior) {
    return null;
  }
}

class WrapperPortGeneratorBehaviorModifier<T extends ValueObjectPropertyWrapper>
    extends PortGeneratorBehaviorModifier<T> {
  @override
  Map<String, PortField> getPortFieldByName(
    T behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final unwrappedBehavior = behavior.property;
    final subModifier = PortDropCoreComponent.getBehaviorModifier(unwrappedBehavior);
    if (subModifier == null) {
      return {};
    }

    final subPortFieldByName = subModifier.getPortFieldByName(unwrappedBehavior, context);
    return subPortFieldByName
        .mapValues((name, portField) => getPortField(behavior, portField, context))
        .where((name, portField) => portField != null)
        .mapValues((name, portField) => portField!);
  }

  @override
  dynamic getHintOrNull(T behavior) {
    final unwrappedBehavior = (behavior as ValueObjectPropertyWrapper).property;
    return PortDropCoreComponent.getBehaviorModifier(unwrappedBehavior)?.getHintOrNull(unwrappedBehavior);
  }
}
