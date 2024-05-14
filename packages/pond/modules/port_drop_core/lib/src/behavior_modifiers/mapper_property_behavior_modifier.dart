import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_drop_core_component.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

class MapperPropertyBehaviorModifier extends PortGeneratorBehaviorModifier<MapperValueObjectProperty> {
  @override
  Map<String, PortField> getPortFieldByName(
    MapperValueObjectProperty behavior,
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
  dynamic getHintOrNull(MapperValueObjectProperty behavior) {
    final unwrappedBehavior = (behavior as ValueObjectPropertyWrapper).property;
    return PortDropCoreComponent.getBehaviorModifier(unwrappedBehavior)?.getHintOrNull(unwrappedBehavior);
  }
}
