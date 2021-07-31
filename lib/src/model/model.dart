import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'future_value.dart';

class Model<T> {
  /// The publisher of the value.
  @protected
  final BehaviorSubject<FutureValue<T>> subject;

  /// Stream of the current value.
  ValueStream<FutureValue<T>> get valueX => subject;

  /// The current value of the model.
  FutureValue<T> get value => valueX.value;

  /// Whether the model is in its initial state.
  bool get isInitial => value is FutureValueInitial;

  /// Whether the model is loaded.
  bool get isLoaded => value is FutureValueLoaded;

  /// Whether the model contains an error.
  bool get isError => value is FutureValueError;

  /// Completer so that multiple [load] calls will wait for the initial [load] to complete.
  Completer? _completer;

  /// A function that loads data to be stored in the model.
  final FutureOr<T> Function() loader;

  Model({required this.loader, T? initialValue})
      : subject = BehaviorSubject.seeded(initialValue == null ? FutureValue.initial() : FutureValue.loaded(value: initialValue));

  factory Model.unloadable(T initialValue) => Model(initialValue: initialValue, loader: () => throw Exception('Cannnot load an unloadable model!'));

  /// Loads the data for the model using the [loader].
  Future<void> load() async {
    // If the model is currently loading something, just wait for the previous load to finish.
    var completer = _completer;

    if (completer != null && !completer.isCompleted) {
      await completer.future;
      return;
    }

    _completer = Completer();

    if (value is FutureValueError) {
      subject.value = FutureValue.initial();
    }

    subject.value = await FutureValue.guard(() async => await loader(), onError: print);

    // Once the model completes loading, notify other [load] calls that the load has finished.
    _completer!.complete();

    _completer = null;
  }

  /// Ensures the model is loaded before returning the loaded value.
  /// If it is in the initial or error state, calls [load] and returns the value,
  /// otherwise returns the last loaded value.
  /// If [onError] is null and an error occurs, just throws the error.
  Future<T?> ensureLoaded({T? onError(dynamic obj)?}) async {
    return await value.maybeWhen(
        loaded: (data) => data,
        orElse: () async {
          await load();
          return value.when(
            initial: () => throw Exception(("Model in initial state after being loaded")),
            loaded: (data) => data,
            error: (error) => onError == null ? throw error ?? Exception('Error loading model!') : onError(error),
          );
        });
  }

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

  /// Sets the loaded value of this model.
  void setLoaded(T value) {
    subject.value = FutureValue.loaded(value: value);
  }

  /// Sets the error value of this model.
  void setError(Object error) {
    subject.value = FutureValue.error(error: error);
  }
}
