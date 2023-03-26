import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:type/type.dart';

class InterfaceFieldBehaviorModifier
    extends PortGeneratorBehaviorModifier<FieldValueObjectProperty<ValueObject?, dynamic>> {
  final TypeContext typeContext;

  InterfaceFieldBehaviorModifier({required this.typeContext});

  @override
  Map<String, PortField> getPortFieldByName(FieldValueObjectProperty<ValueObject?, dynamic> behavior) {
    final baseType = behavior.fieldType;
    return {
      behavior.name: PortField.interfaceRuntime(
        initialValue: behavior.value,
        baseType: baseType,
        typeContext: typeContext,
      )
    };
  }
}
