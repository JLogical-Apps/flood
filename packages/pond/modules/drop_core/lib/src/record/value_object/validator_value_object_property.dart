import 'dart:async';

import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:utils_core/utils_core.dart';

class ValidatorValueObjectProperty<T, S, L>
    with IsValueObjectPropertyWrapper<T, S, L, ValidatorValueObjectProperty<T, S, L>> {
  @override
  final ValueObjectProperty<T, S, L, dynamic> property;

  final Validator<T, String> validator;

  ValidatorValueObjectProperty({required this.property, required this.validator});

  @override
  FutureOr<String?> onValidate(ValueObject data) async {
    final error = await property.validate(data);
    if (error != null) {
      return error;
    }

    return await validator.validate(property.value);
  }

  @override
  ValidatorValueObjectProperty<T, S, L> copy() {
    return ValidatorValueObjectProperty<T, S, L>(property: property.copy(), validator: validator);
  }

  @override
  String get name => property.name;
}
