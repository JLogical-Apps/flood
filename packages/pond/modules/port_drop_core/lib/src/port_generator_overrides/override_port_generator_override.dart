import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_override.dart';
import 'package:port_drop_core/src/port_generator_override_context.dart';
import 'package:utils_core/utils_core.dart';

class OverridePortGeneratorOverride implements PortGeneratorOverride {
  final String fieldName;
  final PortField portField;

  OverridePortGeneratorOverride({required this.fieldName, required this.portField});

  @override
  Map<String, PortField> getModifiedPortFieldByName(
    Map<String, PortField> portFieldByName,
    PortGeneratorOverrideContext context,
  ) {
    return portFieldByName.copy()..set(fieldName, portField);
  }
}
