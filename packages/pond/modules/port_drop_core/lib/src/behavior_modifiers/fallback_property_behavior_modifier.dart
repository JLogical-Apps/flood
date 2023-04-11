import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

class FallbackPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<FallbackValueObjectProperty> {
  FallbackPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(FallbackValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  dynamic getHintOrNull(FallbackValueObjectProperty behavior) {
    return guard(() => behavior.fallback());
  }

  @override
  PortField getPortField(
    FallbackValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    if (isRequiredOnEdit(behavior)) {
      return sourcePortField;
    }

    return sourcePortField.withDynamicHint(() => guard(() {
          final constructedValueObject = context.portDropCoreComponent.getValueObjectFromPort(
            port: context.port,
            originalValueObject: context.originalValueObject,
          );
          final copiedBehavior = constructedValueObject.behaviors
              .whereType<ValueObjectProperty>()
              .where((property) => property.name == behavior.name)
              .first;

          return modifierGetter(copiedBehavior)?.getHintOrNull(copiedBehavior);
        }));
  }
}
