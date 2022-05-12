import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/port/model/port_value_component.dart';
import 'package:jlogical_utils/src/port/model/validation/is_confirm_password_validator.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import 'port.dart';
import 'validation/port_field_validation_context.dart';
import 'validation/port_field_validator.dart';

abstract class PortField<V> extends PortValueComponent<V>
    with WithMultipleValidators<PortFieldValidationContext>
    implements Validator<PortFieldValidationContext> {
  final String name;

  @override
  final List<PortFieldValidator<V>> validators = [];

  final V initialValue;

  late ValueStream<V> valueX;

  V get value => port[name];

  /// Predicate for whether to validate this.
  /// By default, always validates.
  bool Function(V value, Port port) validationPredicate = _defaultValidationPredicate;

  PortField({
    required this.name,
    required this.initialValue,
  });

  @override
  void onInitialize() {
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

  PortField<V> validateIf(bool predicate(V value, Port port)) {
    validationPredicate = predicate;
    return this;
  }

  PortField<V> required() => withSimpleValidator(Validator.required());

  PortField<V> minLength(int minLength) => withSimpleValidator(Validator.minLength(minLength));

  PortField<V> maxLength(int maxLength) => withSimpleValidator(Validator.maxLength(maxLength));

  @override
  Future<void> onValidate(PortFieldValidationContext context) async {
    final shouldValidate = validationPredicate(value, port);
    if (!shouldValidate) {
      return;
    }

    await super.onValidate(context);
  }
}

extension StringPortFieldModelExtensions on PortField<String> {
  PortField<String> isInt() => withSimpleValidator(Validator.isInt());

  PortField<String> isDouble() => withSimpleValidator(Validator.isDouble());

  PortField<String> isCurrency() => withSimpleValidator(Validator.isCurrency());

  PortField<String> isEmail() => withSimpleValidator(Validator.isEmail());

  PortField<String> isPassword() => withSimpleValidator(Validator.isPassword());

  PortField<String> isConfirmPassword() => withValidator(IsConfirmPasswordValidator());
}

bool _defaultValidationPredicate<T>(T value, Port port) {
  return true;
}
