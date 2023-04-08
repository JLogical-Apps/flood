import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/behavior_modifiers/currency_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/display_name_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/double_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/fallback_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/fallback_replacement_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/hidden_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/int_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/is_not_blank_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/multiline_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/placeholder_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/required_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/stage_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/string_field_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class PortDropCoreComponent with IsCorePondComponent {
  late final ModifierResolver<PortGeneratorBehaviorModifier, ValueObjectBehavior> behaviorModifierResolver =
      Resolver.fromModifiers(
    [
      HiddenPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      StringFieldBehaviorModifier(),
      DoubleFieldBehaviorModifier(),
      IntFieldBehaviorModifier(),
      StageFieldBehaviorModifier(
        typeContext: context.locate<TypeCoreComponent>(),
        portCreator: (valueObject) => generatePort(valueObject),
      ),
      FieldBehaviorModifier(),
      RequiredPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      IsNotBlankPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      FallbackPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      FallbackReplacementPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      PlaceholderPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      DisplayNamePropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      MultilinePropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      CurrencyPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
    ],
  );

  PortGeneratorBehaviorModifier? getBehaviorModifierOrNull(ValueObjectBehavior behavior) {
    return behaviorModifierResolver.resolveOrNull(behavior);
  }

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior.dependency<TypeCoreComponent>(),
        CorePondComponentBehavior.dependency<DropCoreComponent>(),
      ];

  Port<V> generatePort<V extends ValueObject>(V valueObject) {
    var portFieldByName = <String, PortField>{};

    late Port<V> port;

    final portBehaviorContext = PortGeneratorBehaviorModifierContext(portGetter: () => port);
    for (final behavior in valueObject.behaviors) {
      final modifier = behaviorModifierResolver.resolveOrNull(behavior);
      if (modifier == null) {
        continue;
      }

      final behaviorPortFieldByName = modifier.getPortFieldByName(behavior, portBehaviorContext);
      portFieldByName = {...portFieldByName, ...behaviorPortFieldByName};
    }

    port = Port.of(portFieldByName).map((sourceData, port) {
      final typeContext = context.locate<TypeCoreComponent>();
      final dropCoreContext = context.locate<DropCoreComponent>();

      final state = State.fromMap(
        sourceData,
        runtimeTypeGetter: (typeName) => typeContext.getByName(typeName),
      );
      final mergedState = valueObject.getState(dropCoreContext).mergeWith(state);

      final newValueObject = typeContext.construct(valueObject.runtimeType) as V;
      newValueObject.copyFrom(dropCoreContext, mergedState);
      return newValueObject;
    });
    return port;
  }
}
