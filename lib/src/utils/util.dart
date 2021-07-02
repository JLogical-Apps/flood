extension ObjectExtensions on Object {
  /// Casts the object to type [T] if possible. Returns null if not possible.
  T? as<T>() {
    if (this is T) {
      return this as T;
    }
    return null;
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
