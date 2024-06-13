import 'dart:async';

import 'package:rxdart/rxdart.dart';

class SwitchMapValueStream<T, R> extends StreamView<R> implements ValueStream<R> {
  final ValueStream<R> source;

  @override
  R value;

  @override
  Object? errorOrNull;

  @override
  StackTrace? stackTrace;

  SwitchMapValueStream._({
    required this.source,
  })  : value = source.value,
        super(source);

  factory SwitchMapValueStream({
    required ValueStream<T> source,
    required ValueStream<R> Function(T data) mapper,
  }) {
    late SwitchMapValueStream<T, R> stream;
    stream = SwitchMapValueStream._(
      source: source
          .switchMap(mapper)
          .doOnData((data) => stream
            ..value = data
            ..errorOrNull = null
            ..stackTrace = null)
          .doOnError((error, stackTrace) => stream
            ..errorOrNull = error
            ..stackTrace = stackTrace)
          .publishValueSeeded(mapper(source.value).value)
          .autoConnect(),
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
