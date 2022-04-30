import 'dart:async';

import 'package:jlogical_utils/src/utils/export.dart';

import '../smart_form_controller.dart';

/// A validation to place on a SmartFormField.
class Validation<T> {
  /// Validates the [value].
  /// Provides [controller] if getting values of other fields is needed.
  /// If successful, returns [null].
  /// Otherwise, returns a user-readable String error message.
  final FutureOr<String?> Function(T value, SmartFormController controller) onValidate;

  const Validation(this.onValidate);

  /// Creates a simple validation without referencing the controller.
  factory Validation.simple(FutureOr<String?> onValidate(T value)) => Validation((value, _) => onValidate(value));

  /// combines multiple validations into one.
  /// When validating, it will linearly go through all the validators and if one fails, returns that error message.
  factory Validation.combine(List<Validation<T>> validators) => Validation((value, controller) {
        for (var validator in validators) {
          var error = validator.validate(value, controller);
          if (error != null) return error;
        }

        return null;
      });

  /// Given the [value] and [controller], returns an error message if the field is invalid. If it is valid, returns null.
  FutureOr<String?> validate(T value, SmartFormController controller) {
    return onValidate(value, controller);
  }

  /*
  ==========[SAMPLE VALIDATORS]==========
   */

  /// Validation that checks whether the value is null or empty.
  /// [onEmpty] is the error message to show when the value is empty.
  static Validation<T> required<T>({String onEmpty: 'Cannot be empty!'}) => Validation.simple((value) {
        // Check for null values.
        if (value == null) {
          return onEmpty;
        }

        // String testing.
        if (value is String) {
          if (value.isBlank) {
            return onEmpty;
          }
        }

        // Bool testing.
        if (value is bool) {
          if (!value) {
            return onEmpty;
          }
        }

        // Generic list testing.
        if (value is List) {
          if (value.isEmpty) {
            return onEmpty;
          }
        }

        return null;
      });

  /// Validation that checks for a minimum length of a text field.
  static Validation<String> minLength(
      {required int minLength, String onTooShort(String text)?, String onEmpty: 'Cannot be empty!'}) {
    var _onTooShort = onTooShort ?? (text) => 'Too short! Need ${minLength - text.length} more characters.';

    return Validation.simple((value) {
      if (value.isEmpty) {
        return onEmpty;
      }

      if (value.length < minLength) {
        return _onTooShort(value);
      }

      return null;
    });
  }

  /// Validation that checks for a maximum length of a text field.
  static Validation<String> maxLength({required int maxLength, String onTooLong(String text)?}) {
    var _onTooLong = onTooLong ?? (text) => 'Too long! Over by ${text.length - maxLength} characters.';

    return Validation.simple((value) {
      if (value.length > maxLength) {
        return _onTooLong(value);
      }

      return null;
    });
  }

  /// Validates whether the text can be parsed to an int.
  /// If the text is empty, it *passes* the validation. If this is not desired, add [Validation.required()] before this.
  static Validation<String> isInteger({String onInvalidParse: 'Invalid integer!'}) => Validation.simple((value) {
        if (value.isEmpty) return null;

        int? parse = value.tryParseIntAfterClean(cleanCommas: false, cleanCurrency: false);
        if (parse == null) {
          return onInvalidParse;
        }

        return null;
      });

  /// Validates whether the text can be parsed to an int.
  /// If the text is empty, it *passes* the validation. If this is not desired, add [Validation.required()] before this.
  static Validation<String> isDouble({String onInvalidParse: 'Invalid number!'}) => Validation.simple((value) {
        if (value.isEmpty) return null;

        double? parse = value.tryParseDoubleAfterClean(cleanCommas: true, cleanCurrency: false);
        if (parse == null) {
          return onInvalidParse;
        }

        return null;
      });

  /// Validates whether the text can be parsed to an int.
  /// If the text is empty, it *passes* the validation. If this is not desired, add [Validation.required()] before this.
  static Validation<String> isCurrency({String onInvalidParse: 'Invalid amount!'}) => Validation.simple((value) {
        if (value.isEmpty) return null;

        double? parse = value.tryParseDoubleAfterClean(cleanCommas: true, cleanCurrency: true);
        if (parse == null) {
          return onInvalidParse;
        }

        return null;
      });

  /// Validates whether the text can be parsed to an email.
  /// If the text is empty, it *passes* the validation. If this is not desired, add [Validation.required()] before this.
  static Validation<String> isEmail({String onInvalid: 'Invalid email!'}) => Validation.simple((value) {
        if (value.isEmpty) return null;

        if (!value.isEmail) {
          return onInvalid;
        }

        return null;
      });

  /// Validates whether the text can be a password by ensuring it is longer than 6 characters.
  static Validation<String> isPassword(
          {String onEmpty: 'Cannot be empty!', String onTooShort: 'Too short! Need at least 6 characters.'}) =>
      Validation.minLength(minLength: 6, onEmpty: onEmpty, onTooShort: (value) => onTooShort);

  /// Validates whether the text matches the text of the password field.
  static Validation<String> isConfirmPassword(
          {required String passwordFieldName,
          String onEmpty: 'Cannot be empty!',
          String onInvalid: 'Does not match password!'}) =>
      Validation((value, controller) {
        if (value.isEmpty) {
          return onEmpty;
        }

        var password = controller.getData<String>(passwordFieldName);

        if (value != password) {
          return onInvalid;
        }

        return null;
      });

  /// Validates whether the numeric input is at least as large as the [minimum].
  static Validation<num> minimum({required num minimum, String onTooSmall(num value)?}) {
    var _onTooSmall = onTooSmall ?? (value) => 'Too small! Must be at least $minimum.';
    return Validation.simple((value) {
      if (value < minimum) {
        return _onTooSmall(value);
      }

      return null;
    });
  }

  /// Validates whether the numeric input is no larger than [maximum].
  static Validation<num> maximum({required num maximum, String onTooLarge(num value)?}) {
    var _onTooLarge = onTooLarge ?? (value) => 'Too large! Cannot be larger than $maximum.';
    return Validation.simple((value) {
      if (value > maximum) {
        return _onTooLarge(value);
      }

      return null;
    });
  }

  /// Validates whether the numeric input is between the range of [minimum] and [maximum] inclusively.
  static Validation<num> range(
          {required num minimum, required num maximum, String onTooSmall(num value)?, String onTooLarge(num value)?}) =>
      Validation.combine([
        Validation.minimum(minimum: minimum, onTooSmall: onTooSmall),
        Validation.maximum(maximum: maximum, onTooLarge: onTooLarge),
      ]);

  /// Validates whether the numeric input is positive, meaning it is not zero or negative.
  static Validation<num> isPositive({String onNegative: 'Cannot be negative!', String onZero: 'Cannot be zero!'}) =>
      Validation.minimum(minimum: double.minPositive, onTooSmall: (value) => value == 0 ? onZero : onNegative);

  /// Validates whether the numeric input is not negative, meaning it can be zero or positive.
  static Validation<num> isNonNegative({String onNegative: 'Cannot be negative!'}) =>
      Validation.minimum(minimum: 0, onTooSmall: (value) => onNegative);

  /// Validates whether the date is before the [latest] date.
  static Validation<DateTime> isBefore({required DateTime latest, String? onBefore}) {
    String _onBefore = onBefore ?? 'Cannot be later than ${latest.formatDate(isLong: false)}!';
    return Validation.simple((value) {
      if (!value.isBefore(latest)) {
        return _onBefore;
      }

      return null;
    });
  }

  /// Validates whether the date is before today.
  static Validation<DateTime> isBeforeNow({String onBefore: 'Cannot be later than today!'}) => Validation.isBefore(
        latest: DateTime.now(),
        onBefore: onBefore,
      );

  /// Validates whether the date is after the [earliest] date.
  static Validation<DateTime> isAfter({required DateTime earliest, String? onAfter}) {
    String _onAfter = onAfter ?? 'Cannot be earlier than ${earliest.formatDate(isLong: false)}';
    return Validation.simple((value) {
      if (!value.isAfter(earliest)) {
        return _onAfter;
      }

      return null;
    });
  }

  /// Validates whether the date is after now.
  static Validation<DateTime> isAfterNow({String onAfter: 'Cannot be earlier than today!'}) => Validation.isAfter(
        earliest: DateTime.now(),
        onAfter: onAfter,
      );

  static Validation<DateTime> dateRange(
          {required DateTime earliest, required DateTime latest, String? onBeforeEarliest, String? onAfterLatest}) =>
      Validation.combine([
        Validation.isAfter(earliest: earliest, onAfter: onAfterLatest),
        Validation.isBefore(latest: latest, onBefore: onBeforeEarliest),
      ]);
}

extension IntValidationExtensions on Validation<int> {
  /// Converts the int validation to one applied to a String input field.
  /// This is useful if a SmartTextField needs to have an input validated as an int.
  /// If the text is empty, it *passes* the validation. If this is not desired, add [Validation.required()] before this.
  Validation<String> fromParsed({
    String onInvalidParse: 'Invalid integer!',
    bool cleanCommas: true,
  }) =>
      Validation((value, controller) {
        if (value.isEmpty) return null;

        int? parse = value.tryParseIntAfterClean(cleanCommas: cleanCommas, cleanCurrency: false);
        if (parse == null) {
          return onInvalidParse;
        }

        return validate(parse, controller);
      });
}

extension DoubleValidationExtensions on Validation<double> {
  /// Converts the double validation to one applied to a String input field.
  /// This is useful if a SmartTextField needs to have an input validated as a double.
  /// If the text is empty, it *passes* the validation. If this is not desired, add [Validation.required()] before this.
  Validation<String> fromParsed({
    String onInvalidParse: 'Invalid number!',
    bool cleanCommas: true,
    bool cleanCurrency: true,
  }) =>
      Validation((value, controller) {
        if (value.isEmpty) return null;

        double? parse = value.tryParseDoubleAfterClean(cleanCommas: cleanCommas, cleanCurrency: cleanCurrency);
        if (parse == null) {
          return onInvalidParse;
        }

        return validate(parse, controller);
      });
}

extension NumValidationExtensions on Validation<num> {
  /// Converts the numeric validation to one applied to a String input field.
  /// This is useful if a SmartTextField needs to have an input validated as a double.
  /// If the text is empty, it *passes* the validation. If this is not desired, add [Validation.required()] before this.
  Validation<String> fromParsed({
    String onInvalidParse: 'Invalid number!',
    bool cleanCommas: true,
    bool cleanCurrency: true,
  }) =>
      Validation((value, controller) {
        if (value.isEmpty) return null;

        double? parse = value.tryParseDoubleAfterClean(cleanCommas: cleanCommas, cleanCurrency: cleanCurrency);
        if (parse == null) {
          return onInvalidParse;
        }

        return validate(parse, controller);
      });
}
