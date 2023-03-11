import 'package:pond_cli/src/automate/command/path/automate_path.dart';
import 'package:pond_cli/src/automate/command/path/automate_path_definition_segment.dart';
import 'package:pond_cli/src/automate/command/property/automate_command_property.dart';
import 'package:pond_cli/src/automate/command/segment/automate_command_property_path_definition_segment.dart';
import 'package:pond_cli/src/automate/command/segment/string_automate_path_definition_segment.dart';
import 'package:pond_cli/src/automate/command/segment/wildcard_automate_path_definition_segment.dart';

abstract class AutomatePathDefinition {
  static AutomatePathDefinition empty = AutomatePathDefinition(segments: []);

  List<AutomatePathDefinitionSegment> get segments;

  factory AutomatePathDefinition({required List<AutomatePathDefinitionSegment> segments}) =>
      _AutomatePathDefinitionImpl(segments: segments);

  static AutomatePathDefinition string(String segment) {
    return AutomatePathDefinition(segments: [StringAutomatePathDefinitionSegment(segment: segment)]);
  }

  static AutomatePathDefinition wildcard() {
    return AutomatePathDefinition(segments: [WildcardAutomatePathDefinitionSegment()]);
  }

  static AutomatePathDefinition property(AutomateCommandProperty property) {
    return AutomatePathDefinition(segments: [AutomateCommandPropertyPathDefinitionSegment(property: property)]);
  }
}

extension AutomatePathDefinitionExtensions on AutomatePathDefinition {
  bool matches(String path) {
    final automatePath = AutomatePath.parse(path);

    if (automatePath.segments.length != segments.length) {
      return false;
    }

    for (var i = 0; i < automatePath.segments.length; i++) {
      final pathSegment = automatePath.segments[i];
      final definitionSegment = segments[i];

      if (!definitionSegment.matches(pathSegment)) {
        return false;
      }
    }

    return true;
  }

  AutomatePathDefinition string(String segment) {
    return AutomatePathDefinition(segments: segments + [StringAutomatePathDefinitionSegment(segment: segment)]);
  }

  AutomatePathDefinition wildcard() {
    return AutomatePathDefinition(segments: segments + [WildcardAutomatePathDefinitionSegment()]);
  }

  AutomatePathDefinition property(AutomateCommandProperty property) {
    return AutomatePathDefinition(
      segments: segments + [AutomateCommandPropertyPathDefinitionSegment(property: property)],
    );
  }
}

mixin IsAutomatePathDefinition implements AutomatePathDefinition {}

class _AutomatePathDefinitionImpl with IsAutomatePathDefinition {
  @override
  final List<AutomatePathDefinitionSegment> segments;

  _AutomatePathDefinitionImpl({required this.segments});
}

abstract class AutomatePathDefinitionWrapper implements AutomatePathDefinition {
  AutomatePathDefinition get pathDefinition;
}

mixin IsAutomatePathDefinitionWrapper implements AutomatePathDefinitionWrapper {
  @override
  List<AutomatePathDefinitionSegment> get segments => pathDefinition.segments;
}
