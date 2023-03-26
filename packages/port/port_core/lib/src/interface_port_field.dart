import 'package:port_core/src/port_field.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class InterfacePortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final TypeContext typeContext;

  final Type baseType;

  InterfacePortField({required this.portField, required this.typeContext, Type? baseType}) : baseType = baseType ?? T;

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return InterfacePortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      typeContext: typeContext,
      baseType: baseType,
    );
  }

  @override
  Validator<T, String> get validator =>
      super.validator +
      Validator((data) {
        if (data == null) {
          return null;
        }

        final baseRuntimeType = typeContext.getRuntimeTypeRuntime(baseType);
        final currentRuntimeType = typeContext.getRuntimeTypeRuntime(data.runtimeType);
        if (!currentRuntimeType.isA(baseRuntimeType)) {
          return '[$data] is not a [$baseRuntimeType]!';
        }

        return null;
      });
}
