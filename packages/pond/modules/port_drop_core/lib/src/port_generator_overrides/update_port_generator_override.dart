import 'package:port_core/src/port_field.dart';
import 'package:port_drop_core/src/port_generator_override.dart';
import 'package:port_drop_core/src/port_generator_override_context.dart';
import 'package:utils_core/utils_core.dart';

class UpdatePortGeneratorOverride implements PortGeneratorOverride {
  final String fieldName;
  final PortField Function(PortField portField) portFieldUpdater;

  UpdatePortGeneratorOverride({required this.fieldName, required this.portFieldUpdater});

  @override
  Map<String, PortField> getModifiedPortFieldByName(
    Map<String, PortField> portFieldByName,
    PortGeneratorOverrideContext context,
  ) {
    final portField = portFieldByName[fieldName];
    if (portField == null) {
      return portFieldByName;
    }

    return portFieldByName.copy()..set(fieldName, portFieldUpdater(portField));
  }
}
