import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/port/model/validation/is_confirm_password_validator.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import 'port.dart';
import 'validation/port_field_validation_context.dart';
import 'validation/port_field_validator.dart';

abstract class PortField<V>
    with WithMultipleValidators<PortFieldValidationContext>
    implements Validator<PortFieldValidationContext> {
  final String name;

  @override
  final List<PortFieldValidator<V>> validators = [];

  final V initialValue;

  late Port port;
  late ValueStream<V> valueX;

  V get value => port[name];

  PortField({
    required this.name,
    required this.initialValue,
  });

  void initialize(Port port) {
    valueX = port.valueByNameX.mapWithValue((valueByName) => valueByName[name]);
  }

  PortField<V> withValidator(PortFieldValidator<V> validator) {
    validators.add(validator);
    return this;
  }

  PortField<V> withSimpleValidator(Validator<V> validator) {
    validators.add(validator.forPort());
    return this;
  }

  PortField<V> required() => withSimpleValidator(Validator.required());

  PortField<V> minLength(int minLength) => withSimpleValidator(Validator.minLength(minLength));

  PortField<V> maxLength(int maxLength) => withSimpleValidator(Validator.maxLength(maxLength));
}

extension StringPortFieldModelExtensions on PortField<String> {
  PortField<String> isInt() => withSimpleValidator(Validator.isInt());

  PortField<String> isDouble() => withSimpleValidator(Validator.isDouble());

  PortField<String> isCurrency() => withSimpleValidator(Validator.isCurrency());

  PortField<String> isEmail() => withSimpleValidator(Validator.isEmail());

  PortField<String> isPassword() => withSimpleValidator(Validator.isPassword());

  PortField<String> isConfirmPassword() => withValidator(IsConfirmPasswordValidator());
}
