import 'dart:async';

extension FutureExtensions<T> on Future<T> {
  Future<T> maybeTimeout(Duration? duration) {
    if (duration == null) {
      return this;
    } else {
      return timeout(duration);
    }
  }
}

extension NullabeFutureExtensions<T> on Future<T>? {
  Future<T2>? mapAsyncIfNonNull<T2>(FutureOr<T2> Function(T value) mapper) {
    final value = this;
    return value == null
        ? null
        : Future(() async {
            final futureValue = await value;
            return await mapper(futureValue);
          });
  }
}
