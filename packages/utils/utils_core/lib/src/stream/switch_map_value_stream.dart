import 'dart:async';

import 'package:rxdart/rxdart.dart';

class SwitchMapValueStream<T, R> extends StreamView<R> implements ValueStream<R> {
  final ValueStream<R> source;

  @override
  R value;

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
          .doOnData((data) => stream.value = data)
          .publishValueSeeded(mapper(source.value).value)
          .autoConnect(),
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
