import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:utils_core/src/future/future_value.dart';
import 'package:utils_core/src/stream/async_map_value_stream.dart';
import 'package:utils_core/src/stream/combine_latest_value_stream.dart';
import 'package:utils_core/src/stream/map_value_stream.dart';
import 'package:utils_core/src/stream/merge_value_stream.dart';
import 'package:utils_core/src/stream/switch_map_value_stream.dart';

extension ValueStreamExtensions<T> on ValueStream<T> {
  /// Maps this value stream to another value stream that contains the last mapped value.
  ValueStream<R> mapWithValue<R>(R Function(T value) mapper) {
    return MapValueStream(source: this, mapper: mapper);
  }

  ValueStream<R> asyncMapWithValue<R>(FutureOr<R> Function(T value) asyncMapper, {required R initialValue}) {
    return AsyncMapValueStream(
      source: this,
      asyncMapper: asyncMapper,
      initialValue: initialValue,
    );
  }

  ValueStream<R> switchMapWithValue<R>(ValueStream<R> Function(T value) mapper) {
    return SwitchMapValueStream(
      source: this,
      mapper: mapper,
    );
  }

  Future waitUntil(bool Function(T value) predicate) async {
    if (predicate(value)) {
      return;
    }

    final completer = Completer();
    final listener = listen((value) {
      if (predicate(value)) {
        completer.complete();
      }
    });
    await completer.future;
    listener.cancel();
  }
}

extension ListValueStreamExtension<T> on List<ValueStream<T>> {
  MergeValueStream<T> mergeValueStream({T? initialValue}) {
    return MergeValueStream<T>(sources: this, initialValue: initialValue);
  }

  ValueStream<R> combineLatestWithValue<R>(R Function(List<T> values) combiner, {R? initialValue}) {
    return CombineLatestValueStream<T, R>(
      sources: this,
      combiner: combiner,
      initialValue: initialValue,
    );
  }
}

extension FutureStreamExtensions<T> on Future<T> {
  /// Maps this Future to a ValueStream that only has two values, the loading value and a loaded/error value.
  ValueStream<FutureValue<T>> asValueStream() {
    final subject = BehaviorSubject<FutureValue<T>>.seeded(FutureValue.loading());
    () async {
      try {
        final value = await this;
        subject.value = FutureValue.loaded(value);
      } catch (e, stackTrace) {
        subject.value = FutureValue.error(e, stackTrace);
      } finally {
        subject.close();
      }
    }();

    return subject;
  }
}
