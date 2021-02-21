import 'package:freezed_annotation/freezed_annotation.dart';

part 'future_value.freezed.dart';

/// A value that stores data that is retrieved in a future.
@freezed
abstract class FutureValue<T> implements _$FutureValue<T> {
  const factory FutureValue.initial() = FutureValueInitial<T>;

  const factory FutureValue.loaded({T value}) = FutureValueLoaded<T>;

  const factory FutureValue.error({dynamic error}) = FutureValueError<T>;

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
