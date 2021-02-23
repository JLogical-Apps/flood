import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../jlogical_utils.dart';

part 'model.g.dart';

class Model<T> = ModelBase<T> with _$Model<T>;

abstract class ModelBase<T> with Store {
  /// The value of the model.
  @observable
  FutureValue<T> value;

  /// Completer so that multiple [load] calls will wait for the initial [load] to complete.
  Completer _completer;

  /// A function that loads data to be stored in the model.
  final FutureOr<T> Function() loader;

  /// Whether the model is in its initial state.
  bool get isInitial => value is FutureValueInitial;

  /// Whether the model is loaded.
  bool get isLoaded => value is FutureValueLoaded;

  /// Whether the model contains an error.
  bool get isError => value is FutureValueError;

  ModelBase({this.loader, T initialValue}) : value = initialValue == null ? FutureValue.initial() : FutureValue.loaded(value: initialValue);

  /// Loads the data for the model using the [loader].
  @action
  Future<void> load() async {
    // If the model is currently loading something, just wait for the previous load to finish.
    if (_completer != null && !_completer.isCompleted) {
      return await _completer.future;
    }

    _completer = Completer();

    if (value is FutureValueError) {
      value = FutureValue.initial();
    }

    value = await FutureValue.guard(() async => await loader());

    // Once the model completes loading, notify other [load] calls that the load has finished.
    _completer.complete();
    _completer = null;
  }

  /// Returns the loaded value of the model, or calls [orElse] if not loaded.
  T get({T orElse()}) {
    return value.maybeWhen(
      loaded: (data) => data,
      orElse: () => orElse != null ? orElse() : throw Exception('get() called without loaded state!'),
    );
  }

  /// Shorthand to getting the model's value.
  T call({T orElse()}) => get(orElse: orElse);

  /// Waits for the model to finish loading and returns the loaded value of the model, or calls [onError] if an error occurred.
  Future<T> complete({T onError(dynamic obj)}) async {
    if (isInitial) {
      await _completer.future;
    }

    return value.when(
      initial: () => throw Exception('Model is in initial state after being loaded.'),
      loaded: (data) => data,
      error: (error) => onError(error),
    );
  }
}
