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
