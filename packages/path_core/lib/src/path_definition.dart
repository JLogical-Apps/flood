import 'package:path_core/path_core.dart';
import 'package:path_core/src/path_definition_builder.dart';
import 'package:path_core/src/path_definition_segment.dart';
import 'package:utils_core/utils_core.dart';

abstract class PathDefinition {
  List<PathDefinitionSegment> get segments;

  factory PathDefinition({required List<PathDefinitionSegment> segments}) => _PathDefinitionImpl(segments: segments);

  static PathDefinitionBuilder builder() {
    return PathDefinitionBuilder();
  }
}

mixin IsPathDefinition implements PathDefinition {}

class _PathDefinitionImpl with IsPathDefinition {
  @override
  final List<PathDefinitionSegment> segments;

  _PathDefinitionImpl({required this.segments});
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
}

abstract class PathDefinitionWrapper implements PathDefinition {
  PathDefinition get pathDefinition;
}

mixin IsPathDefinitionWrapper implements PathDefinitionWrapper {
  @override
  List<PathDefinitionSegment> get segments => pathDefinition.segments;
}
