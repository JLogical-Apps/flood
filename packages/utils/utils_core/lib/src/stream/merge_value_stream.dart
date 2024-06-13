import 'dart:async';

import 'package:rxdart/rxdart.dart';

class MergeValueStream<T> extends StreamView<T> implements ValueStream<T> {
  final List<ValueStream<T>> sources;

  @override
  T value;

  @override
  Object? errorOrNull;

  @override
  StackTrace? stackTrace;

  MergeValueStream._({
    required this.sources,
    required ValueStream<T> mergedValueStream,
    T? initialValue,
  })  : value = initialValue ?? sources.last.value,
        super(mergedValueStream);

  factory MergeValueStream({
    required List<ValueStream<T>> sources,
    T? initialValue,
  }) {
    late MergeValueStream<T> stream;
    stream = MergeValueStream._(
      sources: sources,
      mergedValueStream: MergeStream(sources)
          .doOnData((data) => stream
            ..value = data
            ..errorOrNull = null
            ..stackTrace = null)
          .doOnError((error, stackTrace) => stream
            ..errorOrNull = error
            ..stackTrace = stackTrace)
          .publishValueSeeded(initialValue ?? sources.last.value)
          .autoConnect(),
      initialValue: initialValue,
    );
    return stream;
  }

  @override
  T? get valueOrNull => value;

  @override
  Object get error => errorOrNull!;

  @override
  bool get hasError => errorOrNull != null;

  @override
  bool get hasValue => true;
}
