import 'package:jlogical_utils/src/patterns/validation/validators/length/min_length_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/length/max_length_validator.dart';
import 'package:jlogical_utils/src/patterns/validation/validators/required/required_validator.dart';

import 'validators/email/is_email_validator.dart';
import 'validators/parsing/is_currency_validator.dart';
import 'validators/parsing/is_double_validator.dart';
import 'validators/parsing/is_int_validator.dart';

class Validation {
  Validation._();

  static RequiredValidator required() {
    return RequiredValidator();
  }

  static MinLengthValidator minLength(int minLength) {
    return MinLengthValidator(minLength: minLength);
  }

  static MaxLengthValidator maxLength(int maxLength) {
    return MaxLengthValidator(maxLength: maxLength);
  }

  static IsIntValidator isInt() {
    return IsIntValidator();
  }

  static IsDoubleValidator isDouble() {
    return IsDoubleValidator();
  }

  static IsCurrencyValidator isCurrency() {
    return IsCurrencyValidator();
  }

  static IsEmailValidator isEmail() {
    return IsEmailValidator();
  }
}
