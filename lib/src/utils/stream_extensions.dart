import 'package:rxdart/rxdart.dart';

extension ValueStreamExtensions<T> on ValueStream<T>{
  /// Maps this value stream to another value stream that contains the last mapped value.
  ValueStream<S> mapWithValue<S>(S convert(T value)){
    return map(convert).shareValueSeeded(convert(value));
  }
}