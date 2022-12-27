import 'package:path_core/src/path_definition_segment.dart';
import 'package:path_core/src/property/route_property.dart';
import 'package:path_core/src/segment/route_property_path_definition_segment.dart';
import 'package:path_core/src/segment/string_path_definition_segment.dart';
import 'package:path_core/src/segment/wildcard_path_definition_segment.dart';
import 'package:utils_core/utils_core.dart';

abstract class PathDefinition {
  List<PathDefinitionSegment> get segments;

  factory PathDefinition({required List<PathDefinitionSegment> segments}) => _PathDefinitionImpl(segments: segments);

  static PathDefinition string(String segment) {
    return PathDefinition(segments: [StringPathDefinitionSegment(segment: segment)]);
  }

  static PathDefinition wildcard() {
    return PathDefinition(segments: [WildcardPathDefinitionSegment()]);
  }

  static PathDefinition property(RouteProperty property) {
    return PathDefinition(segments: [RoutePropertyPathDefinitionSegment(property: property)]);
  }
}

extension PathDefinitionExtensions on PathDefinition {
  bool matches(String path) {
    final uri = guard(() => Uri.parse(path));
    if (uri == null) {
      return false;
    }

    if (uri.pathSegments.length != segments.length) {
      return false;
    }

    for (var i = 0; i < uri.pathSegments.length; i++) {
      final uriSegment = uri.pathSegments[i];
      final definitionSegment = segments[i];

      if (!definitionSegment.matches(uriSegment)) {
        return false;
      }
    }

    return true;
  }

  PathDefinition string(String segment) {
    return PathDefinition(segments: segments + [StringPathDefinitionSegment(segment: segment)]);
  }

  PathDefinition wildcard() {
    return PathDefinition(segments: segments + [WildcardPathDefinitionSegment()]);
  }

  PathDefinition property(RouteProperty property) {
    return PathDefinition(segments: segments + [RoutePropertyPathDefinitionSegment(property: property)]);
  }
}

mixin IsPathDefinition implements PathDefinition {}

class _PathDefinitionImpl with IsPathDefinition {
  @override
  final List<PathDefinitionSegment> segments;

  _PathDefinitionImpl({required this.segments});
}

abstract class PathDefinitionWrapper implements PathDefinition {
  PathDefinition get pathDefinition;
}

mixin IsPathDefinitionWrapper implements PathDefinitionWrapper {
  @override
  List<PathDefinitionSegment> get segments => pathDefinition.segments;
}
