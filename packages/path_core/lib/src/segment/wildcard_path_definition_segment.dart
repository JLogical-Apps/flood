import 'package:path_core/src/path_definition_segment.dart';

class WildcardPathDefinitionSegment with IsPathDefinitionSegment {
  WildcardPathDefinitionSegment();

  @override
  bool matches(String segment) {
    return true;
  }
}
