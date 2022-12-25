import 'package:path_core/src/path_definition.dart';
import 'package:path_core/src/path_definition_segment.dart';
import 'package:path_core/src/property/route_property.dart';
import 'package:path_core/src/segment/route_property_path_definition_segment.dart';
import 'package:path_core/src/segment/string_path_definition_segment.dart';
import 'package:path_core/src/segment/wildcard_path_definition_segment.dart';

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

  PathDefinitionBuilder property(RouteProperty property) {
    segments.add(RoutePropertyPathDefinitionSegment(property: property));
    return this;
  }

  PathDefinition build() {
    return PathDefinition(segments: segments);
  }
}
