import 'package:jlogical_utils/src/form/model/validation/form_field_validation_context.dart';
import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/patterns/validation/with_multiple_validators.dart';
import 'package:rxdart/rxdart.dart';

import 'validation/form_field_validator.dart';

abstract class FormFieldModel<V>
    with WithMultipleValidators<FormFieldValidationContext<V>>
    implements Validator<FormFieldValidationContext<V>> {
  final String name;

  @override
  final List<FormFieldValidator<V>> validators;

  final V initialValue;

  late ValueStream<V> valueX;

  V get value => valueX.value;

  FormFieldModel({
    required this.name,
    required this.initialValue,
    this.validators: const [],
  });
}
