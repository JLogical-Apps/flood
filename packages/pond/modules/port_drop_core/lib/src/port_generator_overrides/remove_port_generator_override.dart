import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_override.dart';
import 'package:port_drop_core/src/port_generator_override_context.dart';
import 'package:utils_core/utils_core.dart';

class RemovePortGeneratorOverride implements PortGeneratorOverride {
  final String fieldName;

  RemovePortGeneratorOverride({required this.fieldName});

  @override
  Map<String, PortField> getModifiedPortFieldByName(
    Map<String, PortField> portFieldByName,
    PortGeneratorOverrideContext context,
  ) {
    return portFieldByName.copy()..remove(fieldName);
  }
}
