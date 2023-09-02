import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

class CombineLatestValueStream<T, R> extends StreamView<R> implements ValueStream<R> {
  final List<ValueStream<T>> sources;
  final R Function(List<T> values) combiner;

  @override
  R value;

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
          .doOnData((data) => stream.value = data)
          .publishValueSeeded(initialValue ?? combiner(sources.map((source) => source.value).toList()))
          .autoConnect(),
      initialValue: initialValue,
    );
    return stream;
  }

  @override
  R? get valueOrNull => value;

  @override
  Object get error => sources.firstWhereOrNull((source) => source.errorOrNull != null)!.error;

  @override
  Object? get errorOrNull => sources.firstWhereOrNull((source) => source.errorOrNull != null)?.errorOrNull;

  @override
  bool get hasError => sources.any((source) => source.hasError);

  @override
  bool get hasValue => true;

  @override
  StackTrace? get stackTrace => sources.firstWhereOrNull((source) => source.stackTrace != null)?.stackTrace;
}
