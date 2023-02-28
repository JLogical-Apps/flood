import 'dart:async';

import 'package:utils_core/src/extensions/string_extensions.dart';
import 'package:utils_core/src/validation/compound_validator.dart';

abstract class Validator<T, E> {
  FutureOr<E?> onValidate(T data);

  factory Validator([FutureOr<E?> Function(T data)? validator]) => _ValidatorImpl(validator: validator);

  static Validator<T, E> empty<T, E>() => Validator((data) => null);

  static Validator<T, String> isNotNull<T>() => Validator((data) {
        if (data == null) {
          return 'Cannot be null!';
        }
        return null;
      });

  static Validator<T?, String> isEqualTo<T>(T value) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (value != data) {
          return '[$data] must be equal to [$value]';
        }

        return null;
      });

  static Validator<T?, String> isNotEqualTo<T>(T value) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (value == data) {
          return '[$data] must not be equal to [$value]';
        }

        return null;
      });

  static Validator<num?, String> isGreaterThan(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data <= number) {
          return '[$data] must be greater than [$number]';
        }

        return null;
      });

  static Validator<num?, String> isLessThan(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data >= number) {
          return '[$data] must be less than [$number]';
        }

        return null;
      });

  static Validator<num?, String> isGreaterThanOrEqualTo(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data < number) {
          return '[$data] must be greater than or equal to [$number]';
        }

        return null;
      });

  static Validator<num?, String> isLessThanOrEqualTo(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data > number) {
          return '[$data] must be less than or equal to [$number]';
        }

        return null;
      });

  static Validator<num?, String> isPositive() => isGreaterThan(0);

  static Validator<num?, String> isNegative() => isLessThan(0);

  static Validator<num?, String> isNonNegative() => isGreaterThanOrEqualTo(0);

  static Validator<num?, String> isNonPositive() => isLessThanOrEqualTo(0);

  static Validator<String?, String> isNotBlank() => Validator((data) {
        if (data == null || data.isBlank) {
          return 'Cannot be blank!';
        }

        return null;
      });

  static Validator<String?, String> isEmail() => Validator((data) {
        if (data == null) {
          return null;
        }

        if (!data.isEmail) {
          return '[$data] must be an email!';
        }

        return null;
      });

  static Validator<String?, String> isInt() => Validator((data) {
        if (data == null) {
          return null;
        }

        if (int.tryParse(data) == null) {
          return '[$data] must be an integer!';
        }

        return null;
      });

  static Validator<String?, String> isDouble() => Validator((data) {
        if (data == null) {
          return null;
        }

        if (double.tryParse(data) == null) {
          return '[$data] must be a number!';
        }

        return null;
      });
}

extension ValidatorExtensions<T, E> on Validator<T, E> {
  Future<E?> validate(T data) async {
    return await onValidate(data);
  }

  CompoundValidator<T, E> and(Validator<T, E> validator) {
    return CompoundValidator(validators: [this, validator]);
  }

  Validator<T, E> operator +(Validator<T, E> validator) {
    return and(validator);
  }
}

extension NullableValidatorExtensions<T, E> on Validator<T?, E> {
  Validator<T, E> asNonNullable() => Validator<T, E>(validate);
}

mixin IsValidator<T, E> implements Validator<T, E> {}

class _ValidatorImpl<T, E> with IsValidator<T, E> {
  final FutureOr<E?> Function(T data)? validator;

  _ValidatorImpl({required this.validator});

  @override
  FutureOr<E?> onValidate(T data) async {
    return await validator?.call(data);
  }
}

abstract class ValidatorWrapper<T, E> implements Validator<T, E> {
  Validator<T, E> get validator;
}

mixin IsValidatorWrapper<T, E> implements ValidatorWrapper<T, E> {
  @override
  Future<E?> onValidate(T data) async {
    return await validator.validate(data);
  }
}
