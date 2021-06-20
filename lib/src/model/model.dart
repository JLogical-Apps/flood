import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../jlogical_utils.dart';
import 'package:meta/meta.dart';

class Model<T> extends Modelable<T>{
  /// The publisher of the value.
  @protected
  final BehaviorSubject<FutureValue<T>> subject;

  /// Stream of the current value.
  ValueStream<FutureValue<T>> get valueX => subject;

  /// Completer so that multiple [load] calls will wait for the initial [load] to complete.
  Completer? _completer;

  /// A function that loads data to be stored in the model.
  final FutureOr<T> Function() loader;

  Model({required this.loader, T? initialValue}) : subject = BehaviorSubject.seeded(initialValue == null ? FutureValue.initial() : FutureValue.loaded(value: initialValue));

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

    subject.value = await FutureValue.guard(() async => await loader());

    // Once the model completes loading, notify other [load] calls that the load has finished.
    _completer!.complete();

    _completer = null;
  }

  /// Waits for the model to finish loading and returns the loaded value of the model, or calls [onError] if an error occurred.
  Future<T?> complete({T? onError(dynamic obj)?}) async {
    if (isInitial) {
      await _completer!.future;
    }

    return value.when(
      initial: () => throw Exception('Model is in initial state after being loaded.'),
      loaded: (data) => data,
      error: (error) => onError?.call(error),
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