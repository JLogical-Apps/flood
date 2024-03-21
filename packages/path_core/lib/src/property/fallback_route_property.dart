import 'package:path_core/src/property/route_property.dart';

class FallbackRouteProperty<G, S> with IsRouteProperty<G, S> {
  final RouteProperty<G?, S?> parent;
  final G Function() fallback;

  FallbackRouteProperty({required this.parent, required this.fallback});

  @override
  String get name => parent.name;

  @override
  G get value => parent.value ?? fallback();

  @override
  void set(S value) => parent.set(value);

  @override
  void fromValue(rawValue) {
    parent.fromValue(rawValue);
  }

  @override
  void validate() {
    parent.validate();
  }
}
