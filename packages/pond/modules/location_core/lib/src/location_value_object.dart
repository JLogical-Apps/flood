import 'package:drop_core/drop_core.dart';

class LocationValueObject extends ValueObject {
  static const latitudeField = 'latitude';
  late final latitudeProperty = field<double>(name: latitudeField).required();

  static const longitudeField = 'longitude';
  late final longitudeProperty = field<double>(name: longitudeField).required();

  @override
  List<ValueObjectBehavior> get behaviors => [
        latitudeProperty,
        longitudeProperty,
        creationTime(),
      ];
}
