import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

class PlaceholderPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<PlaceholderValueObjectProperty> {
  PlaceholderPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(PlaceholderValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  dynamic getHintOrNull(PlaceholderValueObjectProperty behavior) {
    return guard(() => behavior.placeholder());
  }

  @override
  PortField getPortField(
    PlaceholderValueObjectProperty behavior,
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
