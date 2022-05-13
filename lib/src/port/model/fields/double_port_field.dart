import '../port_field.dart';

class DoublePortField extends PortField<double> {
  DoublePortField({required super.name, double? initialValue}) : super(initialValue: initialValue ?? 0);
}
