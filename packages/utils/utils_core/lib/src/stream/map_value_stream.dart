import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:utils_core/src/extensions/export.dart';

class MapValueStream<T, R> extends StreamView<R> implements ValueStream<R> {
  final ValueStream<T> source;
  final ValueStream<R> mappedSource;
  final R Function(T value) mapper;

  MapValueStream._({
    required this.source,
    required this.mappedSource,
    required this.mapper,
  }) : super(mappedSource);

  factory MapValueStream({
    required ValueStream<T> source,
    required R Function(T data) mapper,
  }) {
    return MapValueStream._(
      source: source,
      mapper: mapper,
      mappedSource: source.map(mapper).publishValueSeeded(mapper(source.value)).autoConnect(),
    );
  }

  @override
  R get value => mapper(source.value);

  @override
  R? get valueOrNull => source.valueOrNull?.mapIfNonNull((value) => mapper(value));

  @override
  Object get error => mappedSource.error;

  @override
  Object? get errorOrNull => mappedSource.errorOrNull;

  @override
  bool get hasError => mappedSource.hasError;

  @override
  bool get hasValue => mappedSource.hasValue;

  @override
  StackTrace? get stackTrace => mappedSource.stackTrace;
}
