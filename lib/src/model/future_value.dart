import 'package:freezed_annotation/freezed_annotation.dart';

part 'future_value.freezed.dart';

/// A value that stores data that is retrieved in a future.
@freezed
class FutureValue<T> with _$FutureValue<T> {
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
}
