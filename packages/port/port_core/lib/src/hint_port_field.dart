import 'package:port_core/src/port.dart';
import 'package:port_core/src/port_field.dart';

class HintPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final T? Function(Port port) hintGetter;

  HintPortField({required this.portField, required this.hintGetter});

  T? getHint() {
    return hintGetter(port);
  }

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return HintPortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      hintGetter: hintGetter,
    );
  }
}
