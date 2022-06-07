import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/port/model/port_value_component.dart';
import 'package:jlogical_utils/src/port/model/validation/is_confirm_password_validator.dart';

import 'port.dart';
import 'validation/port_field_validation_context.dart';
import 'validation/port_field_validator.dart';

abstract class PortField<V> extends PortValueComponent<V>
    with WithMultipleValidators<PortFieldValidationContext>
    implements Validator<PortFieldValidationContext> {
  final String name;

  final V? initialFallback;

  @override
  final List<PortFieldValidator<V>> validators = [];

  final dynamic initialValue;

  /// Predicate for whether to validate this.
  /// By default, always validates.
  bool Function(V value, Port port) validationPredicate = _defaultValidationPredicate;

  PortField({
    required this.name,
    required this.initialValue,
    this.initialFallback,
  });

  PortField<V> withValidator(PortFieldValidator<V> validator) {
    validators.add(validator);
    return this;
  }

  PortField<V> withValidatorIf(PortFieldValidator<V> validator, {required bool addIf}) {
    if (addIf) {
      validators.add(validator);
    }
    return this;
  }

  PortField<V> withSimpleValidator(Validator<V> validator) {
    validators.add(validator.forPort());
    return this;
  }

  PortField<V> withSimpleValidatorIf(Validator<V> validator, {required bool addIf}) {
    if (addIf) {
      validators.add(validator.forPort());
    }
    return this;
  }

  PortField<V> validateIf(bool predicate(V value, Port port)) {
    validationPredicate = predicate;
    return this;
  }

  PortField<V> required() => withSimpleValidator(Validator.required());

  PortField<V> minLength(int minLength) => withSimpleValidator(Validator.minLength(minLength));

  PortField<V> maxLength(int maxLength) => withSimpleValidator(Validator.maxLength(maxLength));

  PortField<V> isOneOf(List<V> options) => withSimpleValidator(Validator.isOneOf(options));

  @override
  Future<void> onValidate(PortFieldValidationContext context) async {
    final shouldValidate = validationPredicate(value, port);
    if (!shouldValidate) {
      return;
    }

    await super.onValidate(context);
  }
}

extension StringPortFieldModelExtensions on PortField<String?> {
  PortField<String?> isInt() => withSimpleValidator(Validator.isInt());

  PortField<String?> isDouble() => withSimpleValidator(Validator.isDouble());

  PortField<String?> isCurrency() => withSimpleValidator(Validator.isCurrency());

  PortField<String?> isEmail() => withSimpleValidator(Validator.isEmail());

  PortField<String?> isPassword() => withSimpleValidator(Validator.isPassword());

  PortField<String?> isConfirmPassword() => withValidator(IsConfirmPasswordValidator());
}

extension DatePortFieldModelExtensions on PortField<DateTime?> {
  PortField<DateTime?> isBefore(DateTime date) => withSimpleValidator(Validator.isBefore(date));

  PortField<DateTime?> isBeforeNow() => withSimpleValidator(Validator.isBeforeNow());

  PortField<DateTime?> isAfter(DateTime date) => withSimpleValidator(Validator.isAfter(date));

  PortField<DateTime?> isAfterNow() => withSimpleValidator(Validator.isAfterNow());
}

extension NumPortFieldModelExtensions<N extends num> on PortField<N?> {
  PortField<N?> isLessThan(N lessThan) => withSimpleValidator(Validator.isLessThan(lessThan));

  PortField<N?> isGreaterThan(N greaterThan) => withSimpleValidator(Validator.isGreaterThan(greaterThan));

  PortField<N?> range(N min, N max) => withSimpleValidator(Validator.range(min, max));
}

bool _defaultValidationPredicate<T>(T value, Port port) {
  return true;
}
