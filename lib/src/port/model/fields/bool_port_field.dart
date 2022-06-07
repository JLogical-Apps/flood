import '../port_field.dart';

class BoolPortField extends PortField<bool> {
  BoolPortField({required super.name, bool? initialValue, super.initialFallback}) : super(initialValue: initialValue ?? false);
}
