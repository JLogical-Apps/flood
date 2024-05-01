import 'package:port_core/src/port_field.dart';

class PortFieldProvider {
  final PortField? Function(String name) fieldGetter;
  final Function(String name, PortField portField) portFieldSetter;

  PortFieldProvider({required this.fieldGetter, required this.portFieldSetter});

  PortField? getFieldByNameOrNull(String name) => fieldGetter(name);

  void setFieldByName({required String name, required PortField portField}) => portFieldSetter(name, portField);
}
