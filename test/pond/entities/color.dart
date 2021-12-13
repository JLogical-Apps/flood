import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validators.dart';

class Color extends ValueObject {
  late final MapFieldProperty<String, int> rgbProperty = MapFieldProperty(
    name: 'rgb',
    validators: [
      PropertyValidators.required(),
    ],
  );

  @override
  List<Property> get properties => [rgbProperty];
}
