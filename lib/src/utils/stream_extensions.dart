import 'package:rxdart/rxdart.dart';

extension ValueStreamExtensions<T> on ValueStream<T> {
  /// Maps this value stream to another value stream that contains the last mapped value.
  ValueStream<S> mapWithValue<S>(S convert(T value)) {
    return map(convert).publishValueSeeded(convert(value)).autoConnect();
  }

  /// Maps this value stream to value streams, and listens only to the latest created stream.
  ValueStream<S> switchMapWithValue<S>(ValueStream<S> convert(T value)) {
    return switchMap(convert).publishValueSeeded(convert(value).value).autoConnect();
  }
}

extension IterableValueStreamExtensions<T> on Iterable<ValueStream<T>> {
  /// Combines all the value streams in this iterable to a new value stream that contains a combined mapped value.
  ValueStream<S> combineLatestWithValue<S>(S convert(Iterable<T> values)) {
    final value = convert(map((valueStream) => valueStream.value));
    return Rx.combineLatest(this, convert).publishValueSeeded(value).autoConnect();
  }
}
