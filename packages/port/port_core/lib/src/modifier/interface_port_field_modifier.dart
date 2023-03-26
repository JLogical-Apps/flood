import 'package:port_core/src/interface_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:type/type.dart';

class InterfacePortFieldNodeModifier extends WrapperPortFieldNodeModifier<InterfacePortField> {
  InterfacePortFieldNodeModifier({required super.modifierGetter});

  @override
  List<R>? getOptionsOrNull<R>(InterfacePortField portField) {
    final baseRuntimeType = portField.typeContext.getRuntimeTypeRuntime(portField.baseType);
    final descendants = portField.typeContext.getDescendantsOf(baseRuntimeType);

    return descendants.map((type) => type.createInstance()).cast<R>().toList();
  }

  @override
  InterfacePortField? findInterfacePortFieldOrNull(InterfacePortField portField) {
    return portField;
  }
}
