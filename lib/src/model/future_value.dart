import 'package:freezed_annotation/freezed_annotation.dart';

part 'future_value.freezed.dart';

/// A value that stores data that is retrieved in a future.
@freezed
class FutureValue<T> with _$FutureValue<T> {
  const FutureValue._();

  const factory FutureValue.initial() = FutureValueInitial<T>;

  const factory FutureValue.loaded({required T value}) = FutureValueLoaded<T>;

  const factory FutureValue.error({Object? error}) = FutureValueError<T>;

  /// Invokes the future and returns the result of it in a loaded future value.
  /// If an exception occurred, returns an error src.model.
  static Future<FutureValue<T>> guard<T>(Future<T> future()) async {
    try {
      var data = await future();
      return FutureValue.loaded(value: data);
    } catch (ex) {
      return FutureValue.error(error: ex);
    }
  }

  /// Returns the value of the future-value, or [orElse] if in an error/loading state, or throws an exception.
  T get({T orElse()?}) => maybeWhen(loaded: (value) => value, orElse: () => orElse != null ? orElse() : (throw Exception('Called get() on unloaded state.')));

  /// Returns the the value of the future-value, or null if in an error/loading state.
  T? getOrNull() => maybeWhen(loaded: (value) => value, orElse: () => null);

  /// Maps this future-value to one of another type if there is a value present.
  FutureValue<R> mapIfPresent<R>(R mapper(T value)) => when(
        initial: () => FutureValue.initial(),
        loaded: (value) => FutureValue.loaded(value: mapper(value)),
        error: (error) => FutureValue.error(error: error),
      );
}
