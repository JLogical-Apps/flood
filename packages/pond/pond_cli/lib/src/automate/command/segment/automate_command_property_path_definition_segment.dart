import 'package:pond_cli/src/automate/command/path/automate_path_definition_segment.dart';
import 'package:pond_cli/src/automate/command/property/automate_command_property.dart';
import 'package:utils_core/utils_core.dart';

class AutomateCommandPropertyPathDefinitionSegment with IsAutomatePathDefinitionSegment {
  final AutomateCommandProperty property;

  AutomateCommandPropertyPathDefinitionSegment({required this.property});

  @override
  bool matches(String segment) {
    return true;
  }

  @override
  String toSegmentPart() {
    return coerce<String>(property.value);
  }

  @override
  void onMatch(String segment) {
    property.fromValue(segment);
  }
}
