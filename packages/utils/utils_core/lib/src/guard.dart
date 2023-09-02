import 'dart:async';

T? guard<T>(
  T Function() getter, {
  Function(dynamic exception, StackTrace stackTrace)? onException,
}) {
  try {
    return getter();
  } catch (e, stackTrace) {
    onException?.call(e, stackTrace);
    return null;
  }
}

Future<T?> guardAsync<T>(
  FutureOr<T> Function() getter, {
  Function(dynamic exception, StackTrace stackTrace)? onException,
}) async {
  try {
    return await getter();
  } catch (e, stackTrace) {
    onException?.call(e, stackTrace);
    return null;
  }
}
