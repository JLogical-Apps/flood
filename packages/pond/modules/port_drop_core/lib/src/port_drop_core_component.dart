import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/behavior_modifiers/asset_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/bool_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/color_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/currency_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/date_time_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/display_name_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/double_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/fallback_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/fallback_replacement_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/hidden_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/int_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/is_email_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/is_name_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/is_not_blank_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/is_phone_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/list_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/mapper_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/multiline_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/options_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/placeholder_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/reference_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/required_on_edit_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/required_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/string_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/suggestions_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/timestamp_field_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/validator_property_behavior_modifier.dart';
import 'package:port_drop_core/src/behavior_modifiers/value_object_field_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:port_drop_core/src/port_generator_override.dart';
import 'package:port_drop_core/src/port_generator_override_context.dart';
import 'package:runtime_type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class PortDropCoreComponent with IsCorePondComponent {
  static final ModifierResolver<PortGeneratorBehaviorModifier, ValueObjectBehavior> behaviorModifierResolver =
      Resolver.fromModifiers(
    [
      HiddenPropertyBehaviorModifier(),
      OptionsPropertyBehaviorModifier(),
      StringFieldBehaviorModifier(),
      IntFieldBehaviorModifier(),
      BoolFieldBehaviorModifier(),
      DoubleFieldBehaviorModifier(),
      DateTimeFieldBehaviorModifier(),
      TimestampFieldBehaviorModifier(),
      ListFieldBehaviorModifier(),
      AssetPropertyBehaviorModifier(),
      ValueObjectFieldBehaviorModifier(),
      FieldBehaviorModifier(),
      ReferenceBehaviorModifier(),
      RequiredPropertyBehaviorModifier(),
      RequiredOnEditPropertyBehaviorModifier(),
      IsNotBlankPropertyBehaviorModifier(),
      FallbackPropertyBehaviorModifier(),
      FallbackReplacementPropertyBehaviorModifier(),
      PlaceholderPropertyBehaviorModifier(),
      DisplayNamePropertyBehaviorModifier(),
      SuggestionsPropertyBehaviorModifier(),
      MultilinePropertyBehaviorModifier(),
      IsNamePropertyBehaviorModifier(),
      IsEmailPropertyBehaviorModifier(),
      IsPhonePropertyBehaviorModifier(),
      CurrencyPropertyBehaviorModifier(),
      ColorPropertyBehaviorModifier(),
      ValidatorPropertyBehaviorModifier(),
      MapperPropertyBehaviorModifier(),
      WrapperPortGeneratorBehaviorModifier(),
    ],
  );

  static PortGeneratorBehaviorModifier? getBehaviorModifier(ValueObjectBehavior behavior) {
    return behaviorModifierResolver.resolveOrNull(behavior);
  }

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior.dependency<TypeCoreComponent>(),
        CorePondComponentBehavior.dependency<DropCoreComponent>(),
      ];

  DropCoreComponent get dropCoreComponent => context.locate<DropCoreComponent>();

  Port<V> generatePort<V extends ValueObject>(
    V valueObject, {
    List<String>? only,
    List<PortGeneratorOverride> overrides = const [],
    bool validateResult = true,
  }) {
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

    if (only != null) {
      portFieldByName = portFieldByName.where((name, portField) => only.contains(name));
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
      (sourceData, port) async {
        final typeContext = context.locate<TypeCoreComponent>();
        final dropCoreContext = context.locate<DropCoreComponent>();

        final state = State.fromMap(
          sourceData,
          typeContext: typeContext,
        );
        final mergedState = valueObject.getStateUnsafe(dropCoreContext).mergeWith(state).withMetadata({});

        final newValueObject = typeContext.construct(valueObject.runtimeType) as V;
        newValueObject.copyFrom(dropCoreContext, mergedState);
        newValueObject.entity = valueObject.entity;
        newValueObject.idToUse = valueObject.idToUse;
        if (validateResult) {
          await newValueObject.throwIfInvalid(null);
        }
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
      typeContext: typeContext,
    );
    final mergedState =
        originalValueObject == null ? state : originalValueObject.getStateUnsafe(dropCoreContext).mergeWith(state);

    final newValueObject = typeContext.construct(originalValueObject?.runtimeType ?? valueObjectType ?? V) as V;
    newValueObject.copyFromUnsafe(dropCoreContext, mergedState);
    return newValueObject;
  }
}
