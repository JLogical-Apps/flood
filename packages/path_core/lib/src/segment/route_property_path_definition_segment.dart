import 'package:path_core/src/path_definition_segment.dart';
import 'package:path_core/src/property/route_property.dart';
import 'package:utils_core/utils_core.dart';

class RoutePropertyPathDefinitionSegment with IsPathDefinitionSegment {
  final RouteProperty property;

  RoutePropertyPathDefinitionSegment({required this.property});

  @override
  bool matches(String segment) {
    return true;
  }

  @override
  String get segmentPart => coerce<String>(property.value);

  @override
  String get templatePart => ':${property.name}';

  @override
  void onMatch(String segment) {
    property.fromValue(segment);
  }
}
