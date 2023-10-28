import 'package:utils_core/src/type/type_utils.dart';

T coerce<T>(dynamic value) {
  if ((T == int || T == typeOf<int?>()) && value is String) {
    return int.parse(value) as T;
  }
  if ((T == double || T == typeOf<double?>()) && value is String) {
    return double.parse(value) as T;
  }
  if ((T == bool || T == typeOf<bool?>()) && value is String) {
    return bool.parse(value) as T;
  }
  if (T == String || T == typeOf<String?>()) {
    return value.toString() as T;
  }

  return value;
}

T? coerceOrNull<T>(dynamic value) {
  if ((T == int || T == typeOf<int?>()) && value is String) {
    return int.parse(value) as T;
  }
  if ((T == double || T == typeOf<double?>()) && value is String) {
    return double.parse(value) as T;
  }
  if ((T == bool || T == typeOf<bool?>()) && value is String) {
    return bool.parse(value) as T;
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
