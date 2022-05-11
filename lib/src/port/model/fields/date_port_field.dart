import '../port_field.dart';

class DatePortField extends PortField<DateTime> {
  DatePortField({required super.name, DateTime? initialValue}) : super(initialValue: initialValue ?? DateTime.now());
}
