import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class ValueObjectFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<ValueObject?>> {
  @override
  Map<String, PortField> getPortFieldByName(
    FieldValueObjectProperty<ValueObject?> behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return {
      behavior.name: getValueObjectPortField(
        context,
        valueObjectType: behavior.fieldType,
        initialValue: behavior.value,
      ),
    };
  }

  static PortField getValueObjectPortField(
    PortGeneratorBehaviorModifierContext context, {
    bool? isRequiredOnEdit,
    required Type valueObjectType,
    ValueObject? initialValue,
  }) {
    final typeContext = context.corePondContext.dropCoreComponent.typeContext;
    final baseRuntimeType = typeContext.getRuntimeTypeRuntime(valueObjectType);

    final originalBehaviorMetaModifier = BehaviorMetaModifier.getModifier(context.originalBehavior);
    final defaultValue = originalBehaviorMetaModifier?.getDefaultValue(context.originalBehavior) as ValueObject?;
    final onInstantiate = originalBehaviorMetaModifier?.getValueObjectInstantiator(context.originalBehavior);
    isRequiredOnEdit ??= originalBehaviorMetaModifier?.isRequiredOnEdit(context.originalBehavior) ?? false;

    if (defaultValue != null) {
      onInstantiate?.call(defaultValue);
    }
    if (initialValue != null) {
      onInstantiate?.call(initialValue);
    }

    final initialValueObject = initialValue ?? defaultValue;

    final initialRuntimeType =
        initialValueObject?.mapIfNonNull((value) => typeContext.getRuntimeTypeRuntime(value.runtimeType));

    final options = [
      if (baseRuntimeType.isAbstract) ...[
        if (!isRequiredOnEdit) null,
        ...baseRuntimeType.getConcreteDescendants(),
      ] else ...[
        if (!isRequiredOnEdit) null,
        baseRuntimeType,
      ]
    ];

    return options.length == 1
        ? getEmbeddedPortField(
            context,
            valueObjectType: baseRuntimeType,
            initialValueObject: initialValueObject,
            defaultValue: defaultValue,
            onInstantiate: onInstantiate,
          )
        : getStagePortField(
            context,
            initialRuntimeType: initialRuntimeType,
            initialValueObject: initialValueObject,
            defaultValue: defaultValue,
            options: options,
            onInstantiate: onInstantiate,
          );
  }

  static PortField getEmbeddedPortField(
    PortGeneratorBehaviorModifierContext context, {
    required RuntimeType valueObjectType,
    required ValueObject? initialValueObject,
    required ValueObject? defaultValue,
    required void Function(ValueObject valueObject)? onInstantiate,
  }) {
    final valueObject = initialValueObject ?? defaultValue ?? valueObjectType.createInstance();
    onInstantiate?.call(valueObject);

    return PortField.embedded(port: context.corePortDropComponent.generatePort(valueObject));
  }

  static PortField getStagePortField(
    PortGeneratorBehaviorModifierContext context, {
    required RuntimeType? initialRuntimeType,
    required ValueObject? initialValueObject,
    required ValueObject? defaultValue,
    required List<RuntimeType?> options,
    required void Function(ValueObject valueObject)? onInstantiate,
  }) {
    return PortField.stage<RuntimeType?, dynamic>(
      initialValue: initialRuntimeType,
      options: options,
      portMapper: (type) {
        if (type == null) {
          return null;
        }

        if (type == initialRuntimeType && initialValueObject != null) {
          return context.corePortDropComponent.generatePort(initialValueObject);
        }

        final valueObject = type.createInstance();
        onInstantiate?.call(valueObject);
        return context.corePortDropComponent.generatePort(valueObject);
      },
      submitRawMapper: (portValue, type) {
        portValue ??= defaultValue?.asPort(context.corePondContext);
        if (type == null || portValue == null) {
          return null;
        }

        return context.corePortDropComponent.getValueObjectFromPort(
          port: portValue,
          valueObjectType: type.type,
        );
      },
      displayNameMapper: (type) {
        if (type == null) {
          return null;
        }

        final valueObject = type.createInstance() as ValueObject;
        return valueObject.getDisplayName();
      },
    );
  }
}
