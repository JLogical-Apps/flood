import 'package:rxdart/rxdart.dart';

extension ValueStreamExtensions<T> on ValueStream<T> {
  /// Maps this value stream to another value stream that contains the last mapped value.
  ValueStream<R> mapWithValue<R>(R Function(T value) mapper) {
    return map(mapper).publishValueSeeded(mapper(value)).autoConnect();
  }
}
