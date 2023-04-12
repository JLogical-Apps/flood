import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class StageFieldBehaviorModifier
    extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<ValueObject?, dynamic>> {
  final TypeContext typeContext;
  final Port<ValueObject> Function(ValueObject valueObject) portCreator;
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  StageFieldBehaviorModifier({
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

    final initialValueObject = behavior.value ?? defaultValue as ValueObject?;
    final intialRuntimeType =
        initialValueObject?.mapIfNonNull((value) => typeContext.getRuntimeTypeRuntime(value.runtimeType));

    return {
      behavior.name: PortField.stage<RuntimeType?, dynamic>(
          initialValue: intialRuntimeType,
          options: [null, ...baseRuntimeType.getConcreteChildren()],
          portMapper: (type) {
            if (type == null) {
              return null;
            }

            if (type == intialRuntimeType && initialValueObject != null) {
              return portCreator(initialValueObject);
            }

            final valueObject = type.createInstance();
            return portCreator(valueObject);
          },
          displayNameMapper: (type) {
            if (type == null) {
              return null;
            }

            final valueObject = type.createInstance() as ValueObject;
            return valueObject.getDisplayName() ?? valueObject.runtimeType.toString();
          }),
    };
  }
}
