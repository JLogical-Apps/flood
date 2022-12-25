import 'package:path_core/src/path_definition_segment.dart';
import 'package:path_core/src/property/route_property.dart';

class RoutePropertyPathDefinitionSegment with IsPathDefinitionSegment {
  final RouteProperty property;

  RoutePropertyPathDefinitionSegment({required this.property});

  @override
  bool matches(String segment) {
    return true;
  }

  @override
  void onMatch(String segment) {
    property.fromValue(segment);
  }
}
