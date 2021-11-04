import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';

class RequiredPropertyValidator<T> extends PropertyValidator<T> {
  @override
  void validateProperty(T? value) {
    if (value == null) {
      throw Exception('Cannot have a null in a required property!');
    }
  }
}
