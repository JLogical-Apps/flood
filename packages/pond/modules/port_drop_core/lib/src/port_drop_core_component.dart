import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/behavior_modifiers/color_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/currency_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/date_time_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/default_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/display_name_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/double_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/fallback_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/fallback_replacement_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/hidden_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/int_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/is_email_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/is_not_blank_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/multiline_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/null_if_blank_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/only_date_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/placeholder_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/required_on_edit_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/required_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/stage_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/string_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/timestamp_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/validator_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/wrapper_property_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:port_drop_core/src/port_generator_override.dart';
import 'package:port_drop_core/src/port_generator_override_context.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class PortDropCoreComponent with IsCorePondComponent {
  late final ModifierResolver<PortGeneratorBehaviorModifier, ValueObjectBehavior> behaviorModifierResolver =
      Resolver.fromModifiers(
    [
      HiddenPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      StringFieldBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      IntFieldBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      DoubleFieldBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      DateTimeFieldBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      TimestampFieldBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      StageFieldBehaviorModifier(
        portDropContext: context.locate<PortDropCoreComponent>(),
        typeContext: context.locate<TypeCoreComponent>(),
        portCreator: (valueObject) => generatePort(valueObject),
        modifierGetter: getBehaviorModifierOrNull,
      ),
      FieldBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      RequiredPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      RequiredOnEditPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      IsNotBlankPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      FallbackPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      FallbackReplacementPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      PlaceholderPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      DefaultPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      DisplayNamePropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      MultilinePropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      IsEmailPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      NullIfBlankPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      CurrencyPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      ColorPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      OnlyDatePropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      ValidatorPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
      WrapperPropertyBehaviorModifier(modifierGetter: getBehaviorModifierOrNull),
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

  DropCoreComponent get dropCoreComponent => context.locate<DropCoreComponent>();

  Port<V> generatePort<V extends ValueObject>(V valueObject, {List<PortGeneratorOverride> overrides = const []}) {
    var portFieldByName = <String, PortField>{};

    late Port<V> port;

    for (final behavior in valueObject.behaviors) {
      final modifier = behaviorModifierResolver.resolveOrNull(behavior);
      if (modifier == null) {
        continue;
      }

      final portBehaviorContext = PortGeneratorBehaviorModifierContext(
        originalValueObject: valueObject,
        originalBehavior: behavior,
        corePortDropComponent: this,
        corePondContext: context,
        portGetter: () => port,
      );

      final behaviorPortFieldByName = modifier.getPortFieldByName(behavior, portBehaviorContext);
      portFieldByName = {...portFieldByName, ...behaviorPortFieldByName};
    }

    final overrideContext = PortGeneratorOverrideContext(
      initialValueObject: valueObject,
      corePortDropComponent: this,
    );

    portFieldByName = overrides.fold(
      portFieldByName,
      (portFieldByName, override) => override.getModifiedPortFieldByName(portFieldByName, overrideContext),
    );

    port = Port.of(portFieldByName).map(
      (sourceData, port) {
        final typeContext = context.locate<TypeCoreComponent>();
        final dropCoreContext = context.locate<DropCoreComponent>();

        final state = State.fromMap(
          sourceData,
          runtimeTypeGetter: (typeName) => typeContext.getByName(typeName),
        );
        final mergedState = valueObject.getStateUnsafe(dropCoreContext).mergeWith(state);

        final newValueObject = typeContext.construct(valueObject.runtimeType) as V;
        newValueObject.copyFrom(dropCoreContext, mergedState);
        return newValueObject;
      },
      submitType: valueObject.runtimeType,
    );
    return port;
  }

  V getValueObjectFromPort<V extends ValueObject>({
    required Port port,
    V? originalValueObject,
    Type? valueObjectType,
  }) {
    final typeContext = context.locate<TypeCoreComponent>();
    final dropCoreContext = context.locate<DropCoreComponent>();

    final state = State.fromMap(
      port.portFieldByName.map((name, portField) => MapEntry(name, portField.submitRaw(portField.value))),
      runtimeTypeGetter: (typeName) => typeContext.getByName(typeName),
    );
    final mergedState =
        originalValueObject == null ? state : originalValueObject.getStateUnsafe(dropCoreContext).mergeWith(state);

    final newValueObject = typeContext.construct(originalValueObject?.runtimeType ?? valueObjectType ?? V) as V;
    newValueObject.copyFromUnsafe(dropCoreContext, mergedState);
    return newValueObject;
  }
}
