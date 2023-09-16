import 'package:path_core/src/path_definition.dart';
import 'package:path_core/src/path_definition_segment.dart';
import 'package:path_core/src/property/field_route_property.dart';
import 'package:path_core/src/property/route_property.dart';
import 'package:utils_core/utils_core.dart';

abstract class Route<R extends Route<dynamic>> implements PathDefinitionWrapper {
  List<RouteProperty> get queryProperties;

  R copy();
}

extension RouteExtensions<R extends Route<dynamic>> on Route<R> {
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

  R fromPath(String path) {
    if (!matches(path)) {
      throw Exception('[$path] does not match! [$this]');
    }

    final uri = Uri.parse(path);

    final newRoute = copy();

    for (var i = 0; i < uri.pathSegments.length; i++) {
      final uriSegment = uri.pathSegments[i];
      final routeSegment = newRoute.segments[i];

      routeSegment.onMatch(uriSegment);
    }

    for (final queryProperty in newRoute.queryProperties) {
      uri.queryParametersAll[queryProperty.name]?.forEach((value) => queryProperty.fromValue(value));
      queryProperty.validate();
    }

    return newRoute;
  }

  FieldRouteProperty<T> field<T>({required String name}) {
    return FieldRouteProperty<T>(name: name);
  }
}

mixin IsRoute<R extends Route<dynamic>> implements Route<R> {
  @override
  List<RouteProperty> get queryProperties => [];

  @override
  List<PathDefinitionSegment> get segments => pathDefinition.segments;
}

abstract class RouteWrapper<R extends Route<dynamic>> implements Route<R> {
  Route<R> get route;
}

mixin IsRouteWrapper<R extends Route<dynamic>> implements RouteWrapper<R> {
  @override
  List<RouteProperty> get queryProperties => route.queryProperties;

  @override
  R copy() => route.copy();

  @override
  PathDefinition get pathDefinition => route.pathDefinition;

  @override
  List<PathDefinitionSegment> get segments => route.segments;
}
