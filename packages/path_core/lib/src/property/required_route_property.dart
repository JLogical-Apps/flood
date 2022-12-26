import 'package:path_core/src/property/route_property.dart';

class RequiredRouteProperty<T> with IsRouteProperty<T> {
  final RouteProperty<T?> parent;

  RequiredRouteProperty({required this.parent});

  @override
  String get name => parent.name;

  @override
  T get value => parent.value ?? (throw Exception('Required but not found! [$name]'));

  @override
  void fromValue(String rawValue) {
    parent.fromValue(rawValue);
  }

  @override
  void validate() {
    if (parent.value == null) {
      throw Exception('Required but not found! [$name]');
    }
    parent.validate();
  }

  @override
  String? toQueryParameter() {
    return parent.toQueryParameter();
  }
}
