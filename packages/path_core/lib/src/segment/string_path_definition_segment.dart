import 'package:path_core/src/path_definition_segment.dart';

class StringPathDefinitionSegment with IsPathDefinitionSegment {
  final String segment;

  StringPathDefinitionSegment({required this.segment});

  @override
  bool matches(String segment) {
    return segment == this.segment;
  }

  @override
  String toSegmentPart() {
    return segment;
  }
}
