import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../jlogical_utils.dart';

/// A superclass that describes something that holds a FutureValue and can be loaded.
abstract class Modelable<T> {
  /// The stream of the current value of the model.
  ValueStream<FutureValue<T>> get valueX;

  /// The current value of the model.
  FutureValue<T> get value => valueX.value;

  /// Loads the model.
  Future<void> load();

  /// Whether the model is in its initial state.
  bool get isInitial => value is FutureValueInitial;

  /// Whether the model is loaded.
  bool get isLoaded => value is FutureValueLoaded;

  /// Whether the model contains an error.
  bool get isError => value is FutureValueError;

  /// Returns the loaded value of the model, or calls [orElse] if not loaded.
  T get({T orElse()?}) {
    return value.maybeWhen(
      loaded: (data) => data,
      orElse: () => orElse != null ? orElse() : throw Exception('get() called without loaded state!'),
    );
  }

  /// Returns the loaded value of the model or [null] if not loaded. If [orElse] is not null, calls that instead of returning null.
  T? getOrNull({T? orElse()?}) {
    return value.maybeWhen(
      loaded: (data) => data,
      orElse: () => orElse?.call(),
    );
  }
}
