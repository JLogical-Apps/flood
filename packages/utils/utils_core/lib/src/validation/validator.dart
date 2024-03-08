import 'dart:async';

import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:utils_core/src/extensions/string_extensions.dart';
import 'package:utils_core/src/guard.dart';
import 'package:utils_core/src/validation/compound_validator.dart';
import 'package:utils_core/src/validation/map_error_validator.dart';
import 'package:utils_core/src/validation/map_value_validator.dart';

abstract class Validator<T, E> {
  FutureOr<E?> onValidate(T data);

  factory Validator([FutureOr<E?> Function(T data)? validator]) => _ValidatorImpl(validator: validator);

  static Validator<T, E> empty<T, E>() => Validator((data) => null);

  static Validator<T, String> isNotNull<T>() => Validator((data) {
        if (data == null) {
          return 'Cannot be empty!';
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

  static Validator<T, String> isGreaterThan<T extends num?>(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data <= number) {
          return '[$data] must be greater than [$number]';
        }

        return null;
      });

  static Validator<T, String> isLessThan<T extends num?>(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data >= number) {
          return '[$data] must be less than [$number]';
        }

        return null;
      });

  static Validator<T, String> isGreaterThanOrEqualTo<T extends num?>(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data < number) {
          return '[$data] must be greater than or equal to [$number]';
        }

        return null;
      });

  static Validator<T, String> isLessThanOrEqualTo<T extends num?>(num number) => Validator((data) {
        if (data == null) {
          return null;
        }

        if (data > number) {
          return '[$data] must be less than or equal to [$number]';
        }

        return null;
      });

  static Validator<T, String> isPositive<T extends num?>() => isGreaterThan<T>(0);

  static Validator<T, String> isNegative<T extends num?>() => isLessThan<T>(0);

  static Validator<T, String> isNonNegative<T extends num?>() => isGreaterThanOrEqualTo<T>(0);

  static Validator<T, String> isNonPositive<T extends num?>() => isLessThanOrEqualTo<T>(0);

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

  static Validator<String?, String> isPhone() => Validator((data) {
        if (data == null) {
          return null;
        }

        final phoneValid = guard(() => PhoneNumber.parse(data).isValid()) ?? false;
        final usNumberValid = guard(() => PhoneNumber.parse(data, destinationCountry: IsoCode.US).isValid()) ?? false;

        if (!phoneValid && !usNumberValid) {
          return '[$data] must be a phone number!';
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
