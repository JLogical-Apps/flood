class IsNotNullValidationError {
  @override
  String toString() => 'Cannot be empty!';
}

class IsEqualToValidationError<T> {
  final T expected;
  final T actual;

  IsEqualToValidationError(this.expected, this.actual);

  @override
  String toString() => '[$actual] must be equal to [$expected]';
}

class IsNotEqualToValidationError<T> {
  final T value;

  IsNotEqualToValidationError(this.value);

  @override
  String toString() => '[$value] must not be equal to [$value]';
}

class IsGreaterThanValidationError<T> {
  final num threshold;
  final T actual;

  IsGreaterThanValidationError(this.threshold, this.actual);

  @override
  String toString() => '[$actual] must be greater than [$threshold]';
}

class IsLessThanValidationError<T> {
  final num threshold;
  final T actual;

  IsLessThanValidationError(this.threshold, this.actual);

  @override
  String toString() => '[$actual] must be less than [$threshold]';
}

class IsGreaterThanOrEqualToValidationError<T> {
  final num threshold;
  final T actual;

  IsGreaterThanOrEqualToValidationError(this.threshold, this.actual);

  @override
  String toString() => '[$actual] must be greater than or equal to [$threshold]';
}

class IsLessThanOrEqualToValidationError<T> {
  final num threshold;
  final T actual;

  IsLessThanOrEqualToValidationError(this.threshold, this.actual);

  @override
  String toString() => '[$actual] must be less than or equal to [$threshold]';
}

class IsNotBlankValidationError {
  @override
  String toString() => 'Cannot be blank!';
}

class IsNotEmptyValidationError {
  @override
  String toString() => 'Cannot be empty!';
}

class IsEmailValidationError {
  final String email;

  IsEmailValidationError(this.email);

  @override
  String toString() => '[$email] must be a valid email!';
}

class IsPhoneValidationError {
  final String phone;

  IsPhoneValidationError(this.phone);

  @override
  String toString() => '[$phone] must be a valid phone number!';
}

class IsIntValidationError {
  final String value;

  IsIntValidationError(this.value);

  @override
  String toString() => '[$value] must be an integer!';
}

class IsDoubleValidationError {
  final String value;

  IsDoubleValidationError(this.value);

  @override
  String toString() => '[$value] must be a number!';
}

class MaxLengthValidationError {
  final int max;
  final int actual;

  MaxLengthValidationError(this.max, this.actual);

  @override
  String toString() => 'Cannot have more than $max characters!';
}

class MinLengthValidationError {
  final int min;
  final int actual;

  MinLengthValidationError(this.min, this.actual);

  @override
  String toString() => 'Must be longer than $min characters!';
}
