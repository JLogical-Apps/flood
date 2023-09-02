import 'package:pond_cli/src/automate/command/path/automate_path_definition_segment.dart';

class StringAutomatePathDefinitionSegment with IsAutomatePathDefinitionSegment {
  final String segment;

  StringAutomatePathDefinitionSegment({required this.segment});

  @override
  bool matches(String segment) {
    return segment == this.segment;
  }

  @override
  String toSegmentPart() {
    return segment;
  }
}
