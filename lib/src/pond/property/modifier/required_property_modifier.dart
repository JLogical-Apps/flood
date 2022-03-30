import 'package:jlogical_utils/src/pond/property/modifier/property_modifier.dart';
import 'package:jlogical_utils/src/pond/validation/validator.dart';
import 'package:jlogical_utils/src/pond/validation/validation_exception.dart';

class RequiredPropertyModifier<T> extends PropertyModifier<T> {
  @override
  Validator? get validator => Validator.of(() {
        final propertyValue = context.property.getUnvalidated();
        if (propertyValue == null) {
          throw ValidationException(
            failedValidator: context.property,
            errorMessage: 'Null value in required property! [$property]',
          );
        }
      });
}
