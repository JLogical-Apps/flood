import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class ValueObjectFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<ValueObject?>> {
  final PortDropCoreComponent portDropContext;

  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  ValueObjectFieldBehaviorModifier({
    required this.portDropContext,
    required this.modifierGetter,
  });

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
        modifierGetter: modifierGetter,
      ),
    };
  }

  static PortField getValueObjectPortField(
    PortGeneratorBehaviorModifierContext context, {
    bool? isRequiredOnEdit,
    required Type valueObjectType,
    ValueObject? initialValue,
    required PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter,
  }) {
    final typeContext = context.corePondContext.dropCoreComponent.typeContext;
    final baseRuntimeType = typeContext.getRuntimeTypeRuntime(valueObjectType);
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);

    isRequiredOnEdit ??= modifierGetter(context.originalBehavior)?.isRequiredOnEdit(context.originalBehavior) ?? false;

    final initialValueObject = initialValue ?? defaultValue as ValueObject?;
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
            defaultValue: defaultValue as ValueObject?,
          )
        : getStagePortField(
            context,
            initialRuntimeType: initialRuntimeType,
            initialValueObject: initialValueObject,
            defaultValue: defaultValue as ValueObject?,
            options: options,
          );
  }

  static PortField getEmbeddedPortField(
    PortGeneratorBehaviorModifierContext context, {
    required RuntimeType valueObjectType,
    required ValueObject? initialValueObject,
    required ValueObject? defaultValue,
  }) {
    final valueObject = initialValueObject ?? defaultValue ?? valueObjectType.createInstance();
    return PortField.embedded(port: context.corePortDropComponent.generatePort(valueObject));
  }

  static PortField getStagePortField(
    PortGeneratorBehaviorModifierContext context, {
    required RuntimeType? initialRuntimeType,
    required ValueObject? initialValueObject,
    required ValueObject? defaultValue,
    required List<RuntimeType?> options,
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
        return valueObject.getDisplayName() ?? valueObject.runtimeType.toString();
      },
    ).withValidator(Validator((context) {
      final stageValue = context.value as StageValue?;
      if (stageValue?.value == null) {
        return 'Cannot have an empty value!';
      }

      return null;
    }));
  }
}
