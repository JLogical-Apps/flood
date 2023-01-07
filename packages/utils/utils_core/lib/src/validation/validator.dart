import 'dart:async';

import 'package:utils_core/src/extensions/string_extensions.dart';
import 'package:utils_core/src/validation/compound_validator.dart';

abstract class Validator<T, E> {
  FutureOr<E?> onValidate(T data);

  factory Validator([FutureOr<E?> Function(T data)? validator]) => _ValidatorImpl(validator: validator);

  static Validator<T, Exception> isNotNull<T>() => Validator((data) {
        if (data == null) {
          return Exception('Cannot be null!');
        }
        return null;
      });

  static Validator<T?, Exception> isEqualTo<T>(T value) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (value != data) {
          return Exception('[$data] must be equal to [$value]');
        }

        return null;
      });

  static Validator<T?, Exception> isNotEqualTo<T>(T value) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (value == data) {
          return Exception('[$data] must not be equal to [$value]');
        }

        return null;
      });

  static Validator<num?, Exception> isGreaterThan(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data <= number) {
          return Exception('[$data] must be greater than [$number]');
        }

        return null;
      });

  static Validator<num?, Exception> isLessThan(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data >= number) {
          return Exception('[$data] must be less than [$number]');
        }

        return null;
      });

  static Validator<num?, Exception> isGreaterThanOrEqualTo(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data < number) {
          return Exception('[$data] must be greater than or equal to [$number]');
        }

        return null;
      });

  static Validator<num?, Exception> isLessThanOrEqualTo(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data > number) {
          return Exception('[$data] must be less than or equal to [$number]');
        }

        return null;
      });

  static Validator<num?, Exception> isPositive() => isGreaterThan(0);

  static Validator<num?, Exception> isNegative() => isLessThan(0);

  static Validator<num?, Exception> isNonNegative() => isGreaterThanOrEqualTo(0);

  static Validator<num?, Exception> isNonPositive() => isLessThanOrEqualTo(0);

  static Validator<String?, Exception> isNotBlank() => Validator((data) {
        if (data == null || data.trim().isEmpty) {
          return Exception('Cannot be blank!');
        }

        return null;
      });

  static Validator<String?, Exception> isEmail() => Validator((data) {
        if (data == null) {
          return null;
        }

        if (!data.isEmail) {
          return Exception('[$data] must be an email!');
        }

        return null;
      });

  static Validator<String?, Exception> isInt() => Validator((data) {
        if (data == null) {
          return null;
        }

        if (int.tryParse(data) == null) {
          return Exception('[$data] must be an integer!');
        }

        return null;
      });

  static Validator<String?, Exception> isDouble() => Validator((data) {
        if (data == null) {
          return null;
        }

        if (double.tryParse(data) == null) {
          return Exception('[$data] must be a number!');
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
    return await validator.onValidate(data);
  }
}
