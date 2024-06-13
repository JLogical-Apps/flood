import 'dart:async';

import 'package:rxdart/rxdart.dart';

class AsyncMapValueStream<T, R> extends StreamView<R> implements ValueStream<R> {
  final ValueStream<R> source;

  @override
  R value;

  @override
  Object? errorOrNull;

  @override
  StackTrace? stackTrace;

  AsyncMapValueStream._({
    required this.source,
    required R initialValue,
  })  : value = initialValue,
        super(source);

  factory AsyncMapValueStream({
    required ValueStream<T> source,
    required FutureOr<R> Function(T data) asyncMapper,
    required R initialValue,
  }) {
    late AsyncMapValueStream<T, R> stream;
    stream = AsyncMapValueStream._(
      source: source
          .asyncMap(asyncMapper)
          .doOnData((data) => stream
            ..value = data
            ..errorOrNull = null
            ..stackTrace = null)
          .doOnError((error, stackTrace) => stream
            ..errorOrNull = error
            ..stackTrace = stackTrace)
          .publishValueSeeded(initialValue)
          .autoConnect(),
      initialValue: initialValue,
    );
    return stream;
  }

  @override
  R? get valueOrNull => value;

  @override
  Object get error => errorOrNull!;

  @override
  bool get hasError => errorOrNull != null;

  @override
  bool get hasValue => source.hasValue;
}
