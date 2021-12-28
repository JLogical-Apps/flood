import 'dart:async';

import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:rxdart/rxdart.dart';

extension ValueStreamExtensions<T> on ValueStream<T> {
  /// Returns the value of the stream without needing to listen to it.
  Future<T> getCurrentValue() async {
    final completer = Completer<T>();
    late T value;
    await Future.wait([
      completer.future,
      Future.sync(() {
        late StreamSubscription subscription;
        subscription = listen((event) {
          value = event;
          completer.complete(event);
          subscription.cancel();
        });
      })
    ]);
    return value;
  }

  /// Maps this value stream to another value stream that contains the last mapped value.
  ValueStream<S> mapWithValue<S>(S convert(T value)) {
    return map(convert).publishValueSeeded(convert(value)).autoConnect();
  }

  /// Maps this value stream to value streams, and listens only to the latest created stream.
  ValueStream<S> switchMapWithValue<S>(ValueStream<S> convert(T value)) {
    return switchMap(convert).publishValueSeeded(convert(value).value).autoConnect();
  }
}

extension FutureStreamExtensions<T> on Future<T> {
  /// Maps this Future to a ValueStream that only has two values, the initial value and a loaded/error value.
  ValueStream<FutureValue<T>> asValueStream() {
    final subject = BehaviorSubject<FutureValue<T>>.seeded(FutureValue.initial());
    () async {
      try {
        final value = await this;
        subject.value = FutureValue.loaded(value: value);
      } catch (e) {
        subject.value = FutureValue.error(error: e);
      } finally {
        subject.close();
      }
    }();

    return subject;
  }
}

extension IterableValueStreamExtensions<T> on Iterable<ValueStream<T>> {
  /// Combines all the value streams in this iterable to a new value stream that contains a combined mapped value.
  ValueStream<S> combineLatestWithValue<S>(S convert(Iterable<T> values)) {
    final value = convert(map((valueStream) => valueStream.value));
    return Rx.combineLatest(this, convert).publishValueSeeded(value).autoConnect();
  }
}
