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
  R? mapIfNonNull<R>(R mapper(T value)) {
    if(this == null){
      return null;
    }
    return mapper(this!);
  }
}

/// Runs [func] in a try-catch. If an exception occurred, calls [onError] and returns null.
T? guard<T>(T func(), {void onError(dynamic error)?}) {
  try {
    return func();
  } catch (e) {
    onError?.call(e);
    return null;
  }
}
