import 'package:pond_cli/src/automate/command/path/automate_path_definition_segment.dart';

class WildcardAutomatePathDefinitionSegment with IsAutomatePathDefinitionSegment {
  late String matchedText;

  @override
  bool matches(String segment) {
    return true;
  }

  @override
  void onMatch(String segment) {
    matchedText = segment;
  }

  @override
  String toSegmentPart() {
    return matchedText;
  }
}
