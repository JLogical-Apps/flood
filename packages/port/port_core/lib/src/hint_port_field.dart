import 'package:port_core/src/port_field.dart';

class HintPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final String? Function() hintGetter;

  HintPortField({required this.portField, required this.hintGetter});

  String? getHint() {
    return hintGetter();
  }

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return HintPortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      hintGetter: hintGetter,
    );
  }
}
