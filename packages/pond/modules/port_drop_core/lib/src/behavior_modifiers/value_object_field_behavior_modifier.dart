import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class ValueObjectFieldBehaviorModifier extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<ValueObject?>> {
  final PortDropCoreComponent portDropContext;
  final TypeContext typeContext;

  final Port<ValueObject> Function(ValueObject valueObject) portCreator;
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  ValueObjectFieldBehaviorModifier({
    required this.portDropContext,
    required this.typeContext,
    required this.portCreator,
    required this.modifierGetter,
  });

  @override
  Map<String, PortField> getPortFieldByName(
    FieldValueObjectProperty<ValueObject?> behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final baseType = behavior.fieldType;
    final baseRuntimeType = typeContext.getRuntimeTypeRuntime(baseType);
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);

    final isRequiredOnEdit =
        modifierGetter(context.originalBehavior)?.isRequiredOnEdit(context.originalBehavior) ?? false;

    final initialValueObject = behavior.value ?? defaultValue as ValueObject?;
    final initialRuntimeType =
        initialValueObject?.mapIfNonNull((value) => typeContext.getRuntimeTypeRuntime(value.runtimeType));

    final options = [
      if (baseRuntimeType.isAbstract) ...[
        if (!isRequiredOnEdit || initialRuntimeType == null) null,
        ...baseRuntimeType.getConcreteDescendants(),
      ] else ...[
        if (!isRequiredOnEdit) null,
        baseRuntimeType,
      ]
    ];

    return {
      if (options.length == 1)
        behavior.name: getEmbeddedPortField(
          context,
          valueObjectType: baseRuntimeType,
          initialValueObject: initialValueObject,
          defaultValue: defaultValue as ValueObject?,
        )
      else
        behavior.name: getStagePortField(
          context,
          initialRuntimeType: initialRuntimeType,
          initialValueObject: initialValueObject,
          defaultValue: defaultValue as ValueObject?,
          options: options,
        ),
    };
  }

  PortField getEmbeddedPortField(
    PortGeneratorBehaviorModifierContext context, {
    required RuntimeType valueObjectType,
    required ValueObject? initialValueObject,
    required ValueObject? defaultValue,
  }) {
    final valueObject = initialValueObject ?? defaultValue ?? valueObjectType.createInstance();
    return PortField.embedded(port: portCreator(valueObject));
  }

  PortField getStagePortField(
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
          return portCreator(initialValueObject);
        }

        final valueObject = type.createInstance();
        return portCreator(valueObject);
      },
      submitRawMapper: (portValue, type) {
        portValue ??= defaultValue?.asPort(context.corePondContext);
        if (type == null || portValue == null) {
          return null;
        }

        return portDropContext.getValueObjectFromPort(
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
    );
  }
}
