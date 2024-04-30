import 'package:geolocator/geolocator.dart';
import 'package:location_core/location_core.dart';

extension PositionExtensions on Position {
  LocationValueObject asLocationValueObject() {
    return LocationValueObject()
      ..latitudeProperty.set(latitude)
      ..longitudeProperty.set(longitude);
  }
}
