import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

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

/// Helper for using a value stream.
T useValueStream<T>(ValueStream<T> stream) {
  useStream(stream);
  return stream.value;
}