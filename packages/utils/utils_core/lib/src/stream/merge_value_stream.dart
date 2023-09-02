import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

class MergeValueStream<T> extends StreamView<T> implements ValueStream<T> {
  final List<ValueStream<T>> sources;

  @override
  T value;

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
          .doOnData((data) => stream.value = data)
          .publishValueSeeded(initialValue ?? sources.last.value)
          .autoConnect(),
      initialValue: initialValue,
    );
    return stream;
  }

  @override
  T? get valueOrNull => value;

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
