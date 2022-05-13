import '../port_field.dart';

class IntPortField extends PortField<int> {
  IntPortField({required super.name, int? initialValue}) : super(initialValue: initialValue ?? 0);
}
