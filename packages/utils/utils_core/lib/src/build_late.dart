import 'dart:async';

T buildLate<T>(T Function(T Function() getter) builder) {
  late T value;
  value = builder(() => value);
  return value;
}

Future<T> buildLateAsync<T>(FutureOr<T> Function(T Function() getter) builder) async {
  late T value;
  value = await builder(() => value);
  return value;
}
