import 'dart:async';

import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:utils_core/src/extensions/string_extensions.dart';
import 'package:utils_core/src/guard.dart';
import 'package:utils_core/src/validation/compound_validator.dart';
import 'package:utils_core/src/validation/map_error_validator.dart';
import 'package:utils_core/src/validation/map_value_validator.dart';
import 'package:utils_core/src/validation/validation_errors.dart';

abstract class Validator<T, E> {
  FutureOr<E?> onValidate(T data);

  factory Validator([FutureOr<E?> Function(T data)? validator]) => _ValidatorImpl(validator: validator);

  static Validator<T, E> empty<T, E>() => Validator((data) => null);

  static Validator<T, IsNotNullValidationError> isNotNull<T>() => Validator((data) {
        if (data == null) {
          return IsNotNullValidationError();
        }
        return null;
      });

  static Validator<T?, IsEqualToValidationError<T>> isEqualTo<T>(T value) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (value != data) {
          return IsEqualToValidationError(value, data);
        }

        return null;
      });

  static Validator<T?, IsNotEqualToValidationError<T>> isNotEqualTo<T>(T value) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (value == data) {
          return IsNotEqualToValidationError(value);
        }

        return null;
      });

  static Validator<T, IsGreaterThanValidationError<T>> isGreaterThan<T extends num?>(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data <= number) {
          return IsGreaterThanValidationError(number, data);
        }

        return null;
      });

  static Validator<T, IsLessThanValidationError<T>> isLessThan<T extends num?>(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data >= number) {
          return IsLessThanValidationError(number, data);
        }

        return null;
      });

  static Validator<T, IsGreaterThanOrEqualToValidationError<T>> isGreaterThanOrEqualTo<T extends num?>(num number) =>
      Validator((data) {
        if (data == null) {
          return null;
        }

        if (data < number) {
          return IsGreaterThanOrEqualToValidationError(number, data);
        }

        return null;
      });

  static Validator<T, IsLessThanOrEqualToValidationError<T>> isLessThanOrEqualTo<T extends num?>(num number) =>
      Validator((data) {
        if (data == null) {
          return null;
        }

        if (data > number) {
          return IsLessThanOrEqualToValidationError(number, data);
        }

        return null;
      });

  static Validator<T, IsGreaterThanValidationError> isPositive<T extends num?>() => isGreaterThan<T>(0);

  static Validator<T, IsLessThanValidationError> isNegative<T extends num?>() => isLessThan<T>(0);

  static Validator<T, IsGreaterThanOrEqualToValidationError> isNonNegative<T extends num?>() =>
      isGreaterThanOrEqualTo<T>(0);

  static Validator<T, IsLessThanOrEqualToValidationError> isNonPositive<T extends num?>() => isLessThanOrEqualTo<T>(0);

  static Validator<T, IsNotBlankValidationError> isNotBlank<T extends String?>() => Validator((data) {
        if (data == null || data.isBlank) {
          return IsNotBlankValidationError();
        }

        return null;
      });

  static Validator<List<T>, IsNotEmptyValidationError> isNotEmpty<T>() => Validator((data) {
        if (data.isEmpty) {
          return IsNotEmptyValidationError();
        }

        return null;
      });

  static Validator<String?, IsEmailValidationError> isEmail() => Validator((data) {
        if (data == null || data.isEmpty) {
          return null;
        }

        if (!data.isEmail) {
          return IsEmailValidationError(data);
        }

        return null;
      });

  static Validator<String?, IsPhoneValidationError> isPhone() => Validator((data) {
        if (data == null || data.isEmpty) {
          return null;
        }

        final phone = PhoneNumberUtil.instance;

        final phoneValid = guard(() => phone.isValidNumber(phone.parse(data, null))) ?? false;
        final usNumberValid = guard(() => phone.isValidNumber(phone.parse(data, 'US'))) ?? false;

        if (!phoneValid && !usNumberValid) {
          return IsPhoneValidationError(data);
        }

        return null;
      });

  static Validator<String?, IsIntValidationError> isInt() => Validator((data) {
        if (data == null || data.isEmpty) {
          return null;
        }

        if (int.tryParse(data) == null) {
          return IsIntValidationError(data);
        }

        return null;
      });

  static Validator<String?, IsDoubleValidationError> isDouble() => Validator((data) {
        if (data == null || data.isEmpty) {
          return null;
        }

        if (double.tryParse(data) == null) {
          return IsDoubleValidationError(data);
        }

        return null;
      });
}

extension ValidatorExtensions<T, E> on Validator<T, E> {
  Future<E?> validate(T data) async {
    return await onValidate(data);
  }

  Future<void> throwIfInvalid(T data) async {
    final error = await validate(data);
    if (error != null) {
      throw error;
    }
  }

  CompoundValidator<T, E> and(Validator<T, E> validator) {
    return CompoundValidator(validators: [this, validator]);
  }

  Validator<T, E> operator +(Validator<T, E> validator) {
    return and(validator);
  }

  Validator<T2, E> map<T2>(T Function(T2 data) mapper) {
    return MapValueValidator(validator: this, mapper: mapper);
  }

  Validator<T2, E> cast<T2>() {
    return map<T2>((value) => value as T);
  }

  Validator<T, E2> mapError<E2>(E2 Function(E error) errorMapper) {
    return MapErrorValidator(validator: this, errorMapper: errorMapper);
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
