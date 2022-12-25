import 'package:path_core/src/path_definition_segment.dart';
import 'package:path_core/src/path_defintiion_builder.dart';
import 'package:utils_core/utils_core.dart';

class PathDefinition {
  final List<PathDefinitionSegment> segments;

  PathDefinition({required this.segments});

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

  static PathDefinitionBuilder builder() {
    return PathDefinitionBuilder();
  }
}
