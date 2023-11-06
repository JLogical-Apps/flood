import 'package:utils_core/src/type/type_utils.dart';

T coerce<T>(dynamic value) {
  if (value is String) {
    if (T == int || T == typeOf<int?>()) {
      return int.parse(value) as T;
    }
    if (T == double || T == typeOf<double?>()) {
      return double.parse(value) as T;
    }
    if (T == bool || T == typeOf<bool?>()) {
      return bool.parse(value) as T;
    }
  }

  if (value is int) {
    if (T == double || T == typeOf<double?>()) {
      return value.roundToDouble() as T;
    }
  }

  if (value is double) {
    if (T == int || T == typeOf<int?>()) {
      return value.floor() as T;
    }
  }

  if (T == String || T == typeOf<String?>()) {
    return value.toString() as T;
  }

  return value;
}

T? coerceOrNull<T>(dynamic value) {
  if (value is String) {
    if (T == int || T == typeOf<int?>()) {
      return int.parse(value) as T;
    }
    if (T == double || T == typeOf<double?>()) {
      return double.parse(value) as T;
    }
    if (T == bool || T == typeOf<bool?>()) {
      return bool.parse(value) as T;
    }
  }

  if (value is int) {
    if (T == double || T == typeOf<double?>()) {
      return value.roundToDouble() as T;
    }
  }

  if (value is double) {
    if (T == int || T == typeOf<int?>()) {
      return value.floor() as T;
    }
  }

  if (T == String) {
    if (value == null) {
      return null;
    }
    return value.toString() as T;
  }

  if (T == typeOf<String?>()) {
    return value.toString() as T;
  }

  return value;
}
