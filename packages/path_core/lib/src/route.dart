import 'package:path_core/src/path_definition.dart';
import 'package:path_core/src/property/field_route_property.dart';
import 'package:path_core/src/property/route_property.dart';
import 'package:utils_core/utils_core.dart';

abstract class Route implements PathDefinitionWrapper {
  List<RouteProperty> get queryProperties;
}

extension RouteExtensions on Route {
  Uri get uri {
    final queryParameters = queryProperties
        .mapToMap((queryProperty) => MapEntry(
              queryProperty.name,
              queryProperty.toQueryParameter(),
            ))
        .where((name, value) => value != null);
    return Uri(
      path: '/${segments.map((segment) => Uri.encodeComponent(segment.toSegmentPart())).join('/')}',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }

  void fromPath(String path) {
    if (!matches(path)) {
      throw Exception('[$path] does not match! [$this]');
    }

    final uri = Uri.parse(path);

    for (var i = 0; i < uri.pathSegments.length; i++) {
      final uriSegment = uri.pathSegments[i];
      final routeSegment = segments[i];

      routeSegment.onMatch(uriSegment);
    }

    for (final queryProperty in queryProperties) {
      uri.queryParametersAll[queryProperty.name]?.forEach((value) => queryProperty.fromValue(value));
      queryProperty.validate();
    }
  }

  FieldRouteProperty<T> field<T>({required String name}) {
    return FieldRouteProperty<T>(name: name);
  }
}

mixin IsRoute implements Route {
  @override
  List<RouteProperty> get queryProperties => [];
}
