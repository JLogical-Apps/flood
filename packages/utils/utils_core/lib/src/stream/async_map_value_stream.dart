import 'dart:async';

import 'package:rxdart/rxdart.dart';

class AsyncMapValueStream<T, R> extends StreamView<R> implements ValueStream<R> {
  final ValueStream<R> source;

  @override
  R value;

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
          .doOnData((data) async => stream.value = data)
          .publishValueSeeded(initialValue)
          .autoConnect(),
      initialValue: initialValue,
    );
    return stream;
  }

  @override
  R? get valueOrNull => value;

  @override
  Object get error => source.error;

  @override
  Object? get errorOrNull => source.errorOrNull;

  @override
  bool get hasError => source.hasError;

  @override
  bool get hasValue => source.hasValue;

  @override
  StackTrace? get stackTrace => source.stackTrace;
}
