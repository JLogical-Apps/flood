import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/port_field_validator_context.dart';
import 'package:utils_core/utils_core.dart';

class ListPortField<T, S> with IsPortFieldWrapper<List<T>, List<S>> {
  @override
  final PortField<List<T>, List<S>> portField;

  final List<T>? options;

  ListPortField({required this.portField, required this.options});

  @override
  List<T> parseValue(value) {
    if (value is List) {
      return value.cast<T>();
    }
    return value;
  }

  @override
  PortField<List<T>, List<S>> copyWith({required List value, required error}) {
    return ListPortField(
      portField: portField.copyWith(value: value.cast<T>(), error: error),
      options: options,
    );
  }

  @override
  Validator<PortFieldValidatorContext, String> get validator =>
      portField.validator +
      Validator((context) {
        if (options == null) {
          return null;
        }

        final values = context.value as List<T>;
        for (final value in values) {
          if (!options!.contains(value)) {
            return '[${context.value}] is not a valid choice!';
          }
        }

        return null;
      });
}
