import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'future_value.freezed.dart';

/// A value that stores data that is retrieved in a future.
@freezed
class FutureValue<T> with _$FutureValue<T> {
  const FutureValue._();

  const factory FutureValue.initial() = FutureValueInitial<T>;

  const factory FutureValue.loaded({required T value}) = FutureValueLoaded<T>;

  const factory FutureValue.error({Object? error}) = FutureValueError<T>;

  bool get isLoading => this is FutureValueInitial;

  bool get isLoaded => this is FutureValueLoaded;

  bool get isError => this is FutureValueError;

  /// Invokes the future and returns the result of it in a loaded future value.
  /// If an exception occurred, returns an error src.model.
  static Future<FutureValue<T>> guard<T>(Future<T> future(), {void onError(dynamic error)?}) async {
    late FutureValue<T> value;
    try {
      var data = await future();
      value = FutureValue.loaded(value: data);
    } catch (e, stack) {
      print(e);
      print(stack);
      onError?.call(e);
      value = FutureValue.error(error: e);
    }
    return value;
  }

  static FutureValue<T> ofNullable<T>(T? value) {
    return value == null ? FutureValue.initial() : FutureValue.loaded(value: value);
  }

  /// Returns the value of the future-value, or [orElse] if in an error/loading state, or throws an exception.
  T get({T orElse()?}) => maybeWhen(
      loaded: (value) => value,
      orElse: () => orElse != null ? orElse() : (throw Exception('Called get() on unloaded state.')));

  /// Returns the the value of the future-value. If it is in an error/loading state, calls [orElse] if not null, or returns null.
  T? getOrNull({T? orElse()?}) => maybeWhen(
        loaded: (value) => value,
        orElse: () => orElse?.call(),
      );

  /// Maps this future-value to one of another type if there is a value present.
  FutureValue<R> mapIfPresent<R>(R mapper(T value)) => when(
        initial: () => FutureValue.initial(),
        loaded: (value) => FutureValue.loaded(value: mapper(value)),
        error: (error) => FutureValue.error(error: error),
      );

  /// Performs the [action] if the value is loaded.
  /// Can be chained with [otherwise].
  FutureValue<T> ifPresent(void action(T value)) {
    maybeWhen(loaded: action, orElse: () {});
    return this;
  }

  /// Performs the [action] if the value is not loaded.
  /// Usually chained after [ifPresent].
  void otherwise(void action()) {
    maybeWhen(loaded: (_) {}, orElse: action);
  }

  /// Casts this to another type by casting the loaded value to [R].
  FutureValue<R> cast<R>() {
    return mapIfPresent((value) => value as R);
  }
}
