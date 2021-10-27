import 'dart:async';

import 'package:jlogical_utils/src/model/mapped_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../jlogical_utils.dart';

/// An async value that can be loaded.
abstract class AsyncLoadable<T> {
  /// The stream of async values.
  ValueStream<FutureValue<T>> get valueX;

  /// The current value.
  FutureValue<T> get value => valueX.value;

  /// Whether this is in its initial state.
  bool get isInitial => value is FutureValueInitial;

  /// Whether this is loaded.
  bool get isLoaded => value is FutureValueLoaded;

  /// Whether this contains an error.
  bool get isError => value is FutureValueError;

  /// Completer so that multiple [load] calls will wait for the initial [load] to complete.
  Completer? _completer;

  /// A function that loads data to be stored in this.
  /// This is called whenever [load()] is called.
  FutureOr<T> Function() get loader;

  /// Loads the data for the model using the [loader].
  Future<FutureValue<T>> load() async {
    // If the model is currently loading something, just wait for the previous load to finish.
    var completer = _completer;

    if (completer != null && !completer.isCompleted) {
      await completer.future;
      return value;
    }

    _completer = Completer();

    final loadedValue = await FutureValue.guard(() async => await loader());

    // Once the model completes loading, notify other [load] calls that the load has finished.
    _completer!.complete();

    _completer = null;

    return loadedValue;
  }

  /// If the model is in its initial state, load it.
  Future<void> ensureLoadingStarted() async {
    if (value is FutureValueInitial) {
      await load();
    }
  }

  /// Ensures the model is loaded before returning the loaded value.
  /// If it is in the initial or error state, calls [load] and returns the value
  /// (or null), otherwise returns the last loaded value.
  /// If [onError] is null and an error occurs, just throws the error.
  Future<T?> ensureLoaded({T? onError(dynamic obj)?}) async {
    return await value.maybeWhen(
        loaded: (data) => data,
        orElse: () async {
          var value = await load();
          return value.when(
            initial: () => throw Exception(("Model in initial state after being loaded")),
            loaded: (data) => data,
            error: (error) => onError == null ? throw error ?? Exception('Error loading model!') : onError(error),
          );
        });
  }

  /// Ensures the model is loaded before returning the loaded state.
  /// If it is in the initial or error state, calls [load] and returns the value
  /// (or throws an exception), otherwise returns the last loaded value.
  /// If [onError] is null and an error occurs, just throws the error.
  Future<T> ensureLoadedAndGet({T onError(dynamic error)?}) async {
    await ensureLoaded(onError: onError);
    return get();
  }

  /// Returns the loaded value of the model, or calls [orElse] if not loaded.
  T get({T orElse()?}) => value.get(orElse: orElse);

  /// Returns the loaded value of the model, or calls [orElse] if not loaded, or null otherwise.
  T? getOrNull({T? orElse()?}) => value.getOrNull(orElse: orElse);

  /// Maps this to another async loadable.
  /// Whenever the mapped async loadable calls [load()], it simply calls this async loadable's [load()].
  /// Whenever this async loadable gets an updated value, the value is instantly reflected in the mapped value.
  AsyncLoadable<R> map<R>(R mapper(T value)) => MappedModel(
        mapper: mapper,
        parent: this,
      );
}
