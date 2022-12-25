import 'package:path_core/src/property/required_route_property.dart';

abstract class RouteProperty<T> {
  String get name;

  T get value;

  void fromValue(String rawValue);

  void validate();
}

extension RoutePropertyExtensions<T> on RouteProperty<T> {
  RequiredRouteProperty required() {
    return RequiredRouteProperty(parent: this);
  }
}

mixin IsRouteProperty<T> implements RouteProperty<T> {
  @override
  void validate() {}
}

abstract class RoutePropertyWrapper<T> implements RouteProperty<T> {
  RouteProperty<T> get routeProperty;
}

mixin IsRoutePropertyWrapper<T> implements RoutePropertyWrapper<T> {
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
}
