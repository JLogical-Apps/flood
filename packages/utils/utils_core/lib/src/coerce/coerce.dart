T coerce<T>(dynamic value) {
  if (T == int && value is String) {
    return int.parse(value) as T;
  }
  if (T == double && value is String) {
    return double.parse(value) as T;
  }
  return value;
}
