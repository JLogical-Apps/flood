import '../port_field.dart';

class StringPortField extends PortField<String?> {
  StringPortField({required super.name, super.initialValue});

  @override
  String? valueParser(dynamic rawValue) {
    return rawValue?.toString();
  }
}
