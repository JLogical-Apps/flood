import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'async_loadable.dart';
import 'future_value.dart';

/// An async loadable whose value can be changed programatically.
class Model<T> extends AsyncLoadable<T> {
  /// The publisher of the value stream.
  @protected
  final BehaviorSubject<FutureValue<T>> subject;

  /// Stream of the current value is based on the publisher.
  ValueStream<FutureValue<T>> get valueX => subject;

  @override
  final FutureOr<T> Function() loader;

  Model({required this.loader, T? initialValue})
      : subject = BehaviorSubject.seeded(
            initialValue == null ? FutureValue.initial() : FutureValue.loaded(value: initialValue));

  factory Model.unloadable(T initialValue) =>
      Model(initialValue: initialValue, loader: () => throw Exception('Cannot load an unloadable model!'));

  factory Model.constant(T initialValue) => Model(initialValue: initialValue, loader: () => initialValue);

  @override
  Future<FutureValue<T>> load() async {
    if (value is FutureValueError) {
      subject.value = FutureValue.initial();
    }

    // Before returning the new value, set the publisher's value.
    final newValue = await super.load();
    subject.value = newValue;
    return newValue;
  }

  /// Sets the loaded value of this model.
  void setLoaded(T value) {
    subject.value = FutureValue.loaded(value: value);
  }

  /// Sets the error value of this model.
  void setError(Object error) {
    subject.value = FutureValue.error(error: error);
  }

  /// Clears the value of the model, forcing it to be reloaded before a value can be retrieved.
  void clear() {
    subject.value = FutureValue.initial();
  }
}
