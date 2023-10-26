import 'package:path_core/src/path_definition.dart';
import 'package:path_core/src/path_definition_segment.dart';
import 'package:path_core/src/property/field_route_property.dart';
import 'package:path_core/src/property/route_property.dart';
import 'package:path_core/src/route_data.dart';
import 'package:utils_core/utils_core.dart';

abstract class Route<R extends Route<dynamic>> implements PathDefinitionWrapper {
  List<RouteProperty> get queryProperties;

  List<RouteProperty> get hiddenProperties;

  R copy();
}

extension RouteExtensions<R extends Route<dynamic>> on Route<R> {
  String get pathTemplate => pathDefinition.template;

  Uri get uri {
    final queryParameters = queryProperties
        .mapToMap((queryProperty) => MapEntry(
              queryProperty.name,
              queryProperty.value?.toString(),
            ))
        .where((name, value) => value != null);
    return Uri(
      path: '/${segments.map((segment) => Uri.encodeComponent(segment.segmentPart)).join('/')}',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }

  Map<String, dynamic> get hiddenState =>
      hiddenProperties.mapToMap((property) => MapEntry(property.name, property.value));

  RouteData get routeData => RouteData(uri: uri, hiddenState: hiddenState);

  bool matchesRouteData(RouteData routeData) {
    return matchesUri(routeData.uri);
  }

  R fromRouteData(RouteData routeData) {
    if (!matchesRouteData(routeData)) {
      throw Exception('[$routeData] does not match! [$this]');
    }

    final newRoute = copy();

    for (var i = 0; i < routeData.uri.pathSegments.length; i++) {
      final uriSegment = routeData.uri.pathSegments[i];
      final routeSegment = newRoute.segments[i];

      routeSegment.onMatch(uriSegment);
    }

    for (final queryProperty in newRoute.queryProperties) {
      routeData.uri.queryParametersAll[queryProperty.name]?.forEach((value) => queryProperty.fromValue(value));
      queryProperty.validate();
    }

    for (final hiddenProperty in newRoute.hiddenProperties) {
      final value = routeData.hiddenState[hiddenProperty.name];
      hiddenProperty.fromValue(value);
      hiddenProperty.validate();
    }

    return newRoute;
  }

  R fromUri(Uri uri, {Map<String, dynamic> hiddenState = const {}}) {
    return fromRouteData(RouteData.uri(uri, hiddenState: hiddenState));
  }

  R fromPath(String path, {Map<String, dynamic> hiddenState = const {}}) {
    return fromUri(Uri.parse(path), hiddenState: hiddenState);
  }

  FieldRouteProperty<T> field<T>({required String name}) {
    return FieldRouteProperty<T>(name: name);
  }
}

mixin IsRoute<R extends Route<dynamic>> implements Route<R> {
  @override
  List<RouteProperty> get queryProperties => [];

  @override
  List<RouteProperty> get hiddenProperties => [];

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
  List<RouteProperty> get hiddenProperties => route.hiddenProperties;

  @override
  R copy() => route.copy();

  @override
  PathDefinition get pathDefinition => route.pathDefinition;

  @override
  List<PathDefinitionSegment> get segments => route.segments;
}
