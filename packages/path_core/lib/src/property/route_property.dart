import 'package:path_core/src/property/required_route_property.dart';

abstract class RouteProperty<G, S> {
  String get name;

  G get value;

  void set(S value);

  void fromValue(String rawValue);

  void validate();

  String? toQueryParameter();
}

extension NullableRoutePropertyExtensions<G, S> on RouteProperty<G?, S?> {
  RequiredRouteProperty<G, S> required() {
    return RequiredRouteProperty<G, S>(parent: this);
  }
}

mixin IsRouteProperty<G, S> implements RouteProperty<G, S> {
  @override
  void validate() {}
}

abstract class RoutePropertyWrapper<G, S> implements RouteProperty<G, S> {
  RouteProperty<G, S> get routeProperty;
}

mixin IsRoutePropertyWrapper<G, S> implements RoutePropertyWrapper<G, S> {
  @override
  String get name => routeProperty.name;

  @override
  get value => routeProperty.value;

  @override
  void fromValue(String rawValue) {
    routeProperty.fromValue(rawValue);
  }

  @override
  void validate() {
    routeProperty.validate();
  }

  @override
  String? toQueryParameter() {
    return routeProperty.toQueryParameter();
  }
}
