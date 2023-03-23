import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/wrapper/port_field_node_wrapper.dart';
import 'package:utils_core/utils_core.dart';

class OptionsPortField<T, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final List<T> options;

  OptionsPortField({required this.portField, required this.options});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return OptionsPortField(
      portField: portField.copyWith(value: value, error: error),
      options: options,
    );
  }

  @override
  Validator<T, String> get validator =>
      portField.validator + Validator((item) => options.contains(item) ? null : '[$item] is not a valid choice!');
}

extension OptionsPortFieldExtensions<T, S> on PortField<T, S> {
  List<T>? findOptionsOrNull() {
    return PortFieldNodeWrapper.getWrapperOrNull(this)?.getOptionsOrNull(this);
  }
}
