import 'package:port_core/src/port_field.dart';

class DatePortField<T extends DateTime?, S> with IsPortFieldWrapper<T, S> {
  @override
  final PortField<T, S> portField;

  final bool isDate;
  final bool isTime;

  DatePortField({required this.portField, this.isDate = true, this.isTime = true});

  @override
  PortField<T, S> copyWith({required T value, required error}) {
    return DatePortField<T, S>(
      portField: portField.copyWith(value: value, error: error),
      isDate: isDate,
      isTime: isTime,
    );
  }
}
