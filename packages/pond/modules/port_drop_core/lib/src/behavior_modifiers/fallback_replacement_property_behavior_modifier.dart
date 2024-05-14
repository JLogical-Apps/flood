import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_drop_core_component.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

class FallbackReplacementPropertyBehaviorModifier
    extends WrapperPortGeneratorBehaviorModifier<FallbackReplacementValueObjectProperty> {
  @override
  dynamic getHintOrNull(FallbackReplacementValueObjectProperty behavior) {
    return guard(() => behavior.fallbackReplacement());
  }

  @override
  PortField getPortField(
    FallbackReplacementValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    if (BehaviorMetaModifier.getModifier(behavior)?.isRequiredOnEdit(behavior) ?? false) {
      return sourcePortField;
    }

    return sourcePortField.withDynamicHint((port) => guard(() {
          final constructedValueObject = context.corePortDropComponent.getValueObjectFromPort(
            port: context.port,
            originalValueObject: context.originalValueObject,
          );
          final copiedBehavior = constructedValueObject.behaviors
              .whereType<ValueObjectProperty>()
              .where((property) => property.name == behavior.name)
              .first;

          return PortDropCoreComponent.getBehaviorModifier(copiedBehavior)?.getHintOrNull(copiedBehavior);
        }));
  }
}
