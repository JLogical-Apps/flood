import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class StageFieldBehaviorModifier
    extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<ValueObject?, dynamic>> {
  final TypeContext typeContext;
  final Port<ValueObject> Function(ValueObject valueObject) portCreator;

  StageFieldBehaviorModifier({required this.typeContext, required this.portCreator});

  @override
  Map<String, PortField> getPortFieldByName(FieldValueObjectProperty<ValueObject?, dynamic> behavior) {
    final baseType = behavior.fieldType;
    final baseRuntimeType = typeContext.getRuntimeTypeRuntime(baseType);

    final intialRuntimeType =
        behavior.value?.mapIfNonNull((value) => typeContext.getRuntimeTypeRuntime(value.runtimeType));
    final initialValueObject = behavior.value;

    return {
      behavior.name: PortField.stage<RuntimeType?, dynamic>(
        initialValue: intialRuntimeType,
        options: [null, ...baseRuntimeType.getConcreteChildren()],
        portMapper: (type) {
          if (type == null) {
            return Port.empty();
          }

          if (type == intialRuntimeType && initialValueObject != null) {
            return portCreator(initialValueObject);
          }

          final valueObject = type.createInstance();
          return portCreator(valueObject);
        },
      ),
    };
  }
}
