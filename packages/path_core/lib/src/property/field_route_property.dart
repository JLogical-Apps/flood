import 'package:path_core/src/property/route_property.dart';
import 'package:utils_core/utils_core.dart';

class FieldRouteProperty<T> with IsRouteProperty<T?> {
  @override
  final String name;

  @override
  T? value;

  FieldRouteProperty({required this.name});

  @override
  void fromValue(String rawValue) {
    value = coerce<T>(rawValue);
  }
}
