import 'package:path_core/src/property/route_property.dart';

class RequiredRouteProperty<G, S> with IsRouteProperty<G, S> {
  final RouteProperty<G?, S?> parent;

  RequiredRouteProperty({required this.parent});

  @override
  String get name => parent.name;

  @override
  G get value => parent.value ?? (throw Exception('Required but not found! [$name]'));

  @override
  void set(S value) => parent.set(value);

  @override
  void fromValue(dynamic rawValue) {
    parent.fromValue(rawValue);
  }

  @override
  void validate() {
    if (parent.value == null) {
      throw Exception('Required but not found! [$name]');
    }
    parent.validate();
  }
}
