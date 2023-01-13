import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:utils_core/src/future/future_value.dart';
import 'package:utils_core/src/stream/async_map_value_stream.dart';
import 'package:utils_core/src/stream/map_value_stream.dart';

extension ValueStreamExtensions<T> on ValueStream<T> {
  /// Maps this value stream to another value stream that contains the last mapped value.
  ValueStream<R> mapWithValue<R>(R Function(T value) mapper) {
    return MapValueStream(source: this, mapper: mapper);
  }

  AsyncMapValueStream<T, R> asyncMapWithValue<R>(FutureOr<R> Function(T value) asyncMapper, {required R initialValue}) {
    return AsyncMapValueStream(
      source: this,
      asyncMapper: asyncMapper,
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
