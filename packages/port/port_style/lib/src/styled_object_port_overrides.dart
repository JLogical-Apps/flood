import 'package:collection/collection.dart';
import 'package:port_style/src/styled_object_port_override.dart';

class StyledObjectPortOverrides {
  final List<StyledObjectPortOverride> overrides;

  StyledObjectPortOverrides({required this.overrides});

  StyledObjectPortOverride? getOverrideByTypeOrNullRuntime(Type portSubmitType) {
    return overrides.firstWhereOrNull((override) => override.portType == portSubmitType);
  }
}
