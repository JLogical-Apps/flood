import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_override_context.dart';
import 'package:port_drop_core/src/port_generator_overrides/override_port_generator_override.dart';
import 'package:port_drop_core/src/port_generator_overrides/remove_port_generator_override.dart';
import 'package:port_drop_core/src/port_generator_overrides/update_port_generator_override.dart';

abstract class PortGeneratorOverride {
  Map<String, PortField> getModifiedPortFieldByName(
    Map<String, PortField> portFieldByName,
    PortGeneratorOverrideContext context,
  );

  static PortGeneratorOverride remove(String fieldName) {
    return RemovePortGeneratorOverride(fieldName: fieldName);
  }

  static PortGeneratorOverride override(String fieldName, {required PortField portField}) {
    return OverridePortGeneratorOverride(fieldName: fieldName, portField: portField);
  }

  static PortGeneratorOverride update(
    String fieldName, {
    required PortField Function(PortField) portFieldUpdater,
  }) {
    return UpdatePortGeneratorOverride(
      fieldName: fieldName,
      portFieldUpdater: portFieldUpdater,
    );
  }
}
