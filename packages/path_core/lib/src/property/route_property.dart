import 'package:path_core/src/property/fallback_route_property.dart';
import 'package:path_core/src/property/required_route_property.dart';

abstract class RouteProperty<G, S> {
  String get name;

  G get value;

  void set(S value);

  void fromValue(dynamic rawValue);

  void validate();
}

extension NullableRoutePropertyExtensions<G, S> on RouteProperty<G?, S?> {
  RequiredRouteProperty<G, S> required() {
    return RequiredRouteProperty<G, S>(parent: this);
  }

  FallbackRouteProperty<G, S> withFallback(G Function() fallback) {
    return FallbackRouteProperty<G, S>(parent: this, fallback: fallback);
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
  void fromValue(dynamic rawValue) {
    routeProperty.fromValue(rawValue);
  }

  @override
  void validate() {
    routeProperty.validate();
  }
}
