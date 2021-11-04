import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';
import 'package:jlogical_utils/src/pond/property/validation/required_property_validator.dart';

class PropertyValidators {
  const PropertyValidators._();

  static PropertyValidator<T> required<T>() => RequiredPropertyValidator<T>();
}
