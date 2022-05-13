import '../port_field.dart';

class CurrencyPortField extends PortField<int> {
  CurrencyPortField({required super.name, int? initialValue}) : super(initialValue: initialValue ?? 0);
}
