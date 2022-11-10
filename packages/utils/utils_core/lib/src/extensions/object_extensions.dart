extension ObjectExtensions<T> on T {
  /// Casts the object to type [R] if possible. Returns null if not possible.
  R? as<R>() {
    if (this is R) {
      return this as R;
    }
    return null;
  }
}

extension NullableObjectExtensions<T> on T? {
  /// If this is null, returns null. Otherwise, maps it by using [mapper].
  R? mapIfNonNull<R>(R? Function(T value) mapper) {
    final value = this;
    return value == null ? null : mapper(value);
  }
}
