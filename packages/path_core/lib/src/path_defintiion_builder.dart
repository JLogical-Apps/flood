import 'package:path_core/src/path_definition.dart';
import 'package:path_core/src/path_definition_segment.dart';
import 'package:path_core/src/string_path_definition_segment.dart';
import 'package:path_core/src/wildcard_path_definition_segment.dart';

class PathDefinitionBuilder {
  List<PathDefinitionSegment> segments = [];

  PathDefinitionBuilder string(String segment) {
    segments.add(StringPathDefinitionSegment(segment: segment));
    return this;
  }

  PathDefinitionBuilder wildcard() {
    segments.add(WildcardPathDefinitionSegment());
    return this;
  }

  PathDefinition build() {
    return PathDefinition(segments: segments);
  }
}
