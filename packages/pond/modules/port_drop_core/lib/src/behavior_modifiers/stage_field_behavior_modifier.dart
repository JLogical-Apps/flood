import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class StageFieldBehaviorModifier
    extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<ValueObject?, dynamic>> {
  final CorePortDropComponent portDropContext;
  final TypeContext typeContext;

  final Port<ValueObject> Function(ValueObject valueObject) portCreator;
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  StageFieldBehaviorModifier({
    required this.portDropContext,
    required this.typeContext,
    required this.portCreator,
    required this.modifierGetter,
  });

  @override
  Map<String, PortField> getPortFieldByName(
    FieldValueObjectProperty<ValueObject?, dynamic> behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final baseType = behavior.fieldType;
    final baseRuntimeType = typeContext.getRuntimeTypeRuntime(baseType);
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);

    final options = baseRuntimeType.isAbstract ? baseRuntimeType.getConcreteDescendants() : [baseRuntimeType];

    final initialValueObject = behavior.value ?? defaultValue as ValueObject?;
    final initialRuntimeType =
        initialValueObject?.mapIfNonNull((value) => typeContext.getRuntimeTypeRuntime(value.runtimeType));

    final isRequiredOnEdit =
        modifierGetter(context.originalBehavior)?.isRequiredOnEdit(context.originalBehavior) ?? false;

    Port? getPort(RuntimeType? type) {
      if (type == null) {
        return null;
      }

      if (type == initialRuntimeType && initialValueObject != null) {
        return portCreator(initialValueObject);
      }

      final valueObject = type.createInstance();
      return portCreator(valueObject);
    }

    return {
      behavior.name: PortField.stage<RuntimeType?, dynamic>(
        initialValue: initialRuntimeType,
        options: [
          if (!isRequiredOnEdit || initialRuntimeType == null) null,
          ...options,
        ],
        portMapper: (type) => getPort(type),
        submitRawMapper: (portValue, type) {
          portValue ??= (defaultValue as ValueObject?)?.asPort(context.corePondContext);
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
      ),
    };
  }
}
