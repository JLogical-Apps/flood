import 'package:port_core/src/port_field.dart';

class CurrencyPortField<T extends int?, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final bool isCurrency;

  CurrencyPortField({required this.portField, this.isCurrency = true});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return CurrencyPortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      isCurrency: isCurrency,
    );
  }
}
