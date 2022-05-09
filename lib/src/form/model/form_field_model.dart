import 'package:jlogical_utils/src/form/model/validation/form_field_validation_context.dart';
import 'package:jlogical_utils/src/form/model/validation/is_confirm_password_validator.dart';
import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import 'form_model.dart';
import 'validation/form_field_validator.dart';

class FormFieldModel<V>
    with WithMultipleValidators<FormFieldValidationContext>
    implements Validator<FormFieldValidationContext> {
  final String name;

  @override
  final List<FormFieldValidator<V>> validators = [];

  final V initialValue;

  late FormModel form;
  late ValueStream<V> valueX;

  V get value => form[name];

  FormFieldModel({
    required this.name,
    required this.initialValue,
  });

  void initialize(FormModel form) {
    valueX = form.valueByNameX.mapWithValue((valueByName) => valueByName[name]);
  }

  FormFieldModel<V> withValidator(FormFieldValidator<V> validator) {
    validators.add(validator);
    return this;
  }

  FormFieldModel<V> withSimpleValidator(Validator<V> validator) {
    validators.add(validator.forForm());
    return this;
  }

  FormFieldModel<V> required() => withSimpleValidator(Validator.required());

  FormFieldModel<V> minLength(int minLength) => withSimpleValidator(Validator.minLength(minLength));

  FormFieldModel<V> maxLength(int maxLength) => withSimpleValidator(Validator.maxLength(maxLength));
}

extension StringFormFieldModelExtensions on FormFieldModel<String> {
  FormFieldModel<String> isInt() => withSimpleValidator(Validator.isInt());

  FormFieldModel<String> isDouble() => withSimpleValidator(Validator.isDouble());

  FormFieldModel<String> isCurrency() => withSimpleValidator(Validator.isCurrency());

  FormFieldModel<String> isEmail() => withSimpleValidator(Validator.isEmail());

  FormFieldModel<String> isPassword() => withSimpleValidator(Validator.isPassword());

  FormFieldModel<String> isConfirmPassword() => withValidator(IsConfirmPasswordValidator());
}
