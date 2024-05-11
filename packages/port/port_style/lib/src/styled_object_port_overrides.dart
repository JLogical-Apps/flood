import 'package:collection/collection.dart';
import 'package:port_style/src/styled_object_port_override.dart';
import 'package:runtime_type/type.dart';

class StyledObjectPortOverrides {
  final List<StyledObjectPortOverride> overrides;

  StyledObjectPortOverrides({required this.overrides});

  StyledObjectPortOverride? getOverrideByTypeOrNullRuntime(TypeContext context, Type portSubmitType) {
    final override = overrides.firstWhereOrNull((override) => override.portType == portSubmitType);
    if (override != null) {
      return override;
    }

    final inheritanceOverride = overrides.firstWhereOrNull((override) {
      final portSubmitRuntimeType = context.getRuntimeTypeOrNullRuntime(portSubmitType);
      final portTypeRuntimeType = context.getRuntimeTypeOrNullRuntime(override.portType);
      if (portSubmitRuntimeType == null || portTypeRuntimeType == null) {
        return false;
      }

      return portSubmitRuntimeType.isA(portTypeRuntimeType);
    });
    if (inheritanceOverride != null) {
      return inheritanceOverride;
    }

    return null;
  }
}
