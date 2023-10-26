import 'package:path_core/src/path_definition_segment.dart';

class WildcardPathDefinitionSegment with IsPathDefinitionSegment {
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
  String get segmentPart => matchedText;

  @override
  String get templatePart => '*';
}
