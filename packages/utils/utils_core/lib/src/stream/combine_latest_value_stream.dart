import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CombineLatestValueStream<T, R> extends StreamView<R> implements ValueStream<R> {
  final List<ValueStream<T>> sources;
  final R Function(List<T> values) combiner;

  @override
  R value;

  @override
  Object? errorOrNull;

  @override
  StackTrace? stackTrace;

  CombineLatestValueStream._({
    required this.sources,
    required this.combiner,
    required ValueStream<R> combinedValueStream,
    R? initialValue,
  })  : value = initialValue ?? combiner(sources.map((source) => source.value).toList()),
        super(combinedValueStream);

  factory CombineLatestValueStream({
    required List<ValueStream<T>> sources,
    required R Function(List<T> values) combiner,
    R? initialValue,
  }) {
    late CombineLatestValueStream<T, R> stream;
    stream = CombineLatestValueStream._(
      sources: sources,
      combiner: combiner,
      combinedValueStream: CombineLatestStream<T, R>(sources, combiner)
          .distinct()
          .doOnData((data) => stream
            ..value = data
            ..errorOrNull = null
            ..stackTrace = null)
          .doOnError((error, stackTrace) {
            stream
              ..errorOrNull = error
              ..stackTrace = stackTrace;
          })
          .publishValueSeeded(initialValue ?? combiner(sources.map((source) => source.value).toList()))
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
  bool get hasValue => true;
}
