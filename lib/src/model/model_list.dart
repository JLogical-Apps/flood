import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:mobx/mobx.dart';

part 'model_list.g.dart';

class ModelList<T> = ModelListBase<T> with _$ModelList<T>;

abstract class ModelListBase<T> with Store {
  /// The models in the list.
  @observable
  FutureValue<List<Model<T>>> models;

  /// A function that loads data to be stored in the model.
  FutureOr<Map<String, T>> Function() loader;

  /// Completer so that multiple [load] calls will wait for the initial [load] to complete.
  Completer _completer;

  /// Passed in converter that converts entities with ids into a model.
  Model<T> Function(String id, T entity) converter;

  /// Whether the model is in its initial state.
  bool get isInitial => models is FutureValueInitial;

  /// Whether the model is loaded.
  bool get isLoaded => models is FutureValueLoaded;

  /// Whether the model contains an error.
  bool get isError => models is FutureValueError;

  ModelListBase({this.loader, this.converter, List<Model<T>> initialModels}) : models = initialModels == null ? FutureValue.initial() : FutureValue.loaded(value: initialModels);

  /// Loads the models using the loader.
  @action
  Future<void> load() async {
    // If the model is currently loading something, just wait for the previous load to finish.
    if (_completer != null && !_completer.isCompleted) {
      return await _completer.future;
    }

    _completer = Completer();

    if (models is FutureValueError) {
      models = FutureValue.initial();
    }

    models = await FutureValue.guard(() async => (await loader()).entries.map((entry) => converter(entry.key, entry.value)).toList());

    // Once the model completes loading, notify other [load] calls that the load has finished.
    _completer.complete();
    _completer = null;
  }

  /// Returns the loaded value of the model, or calls [orElse] if not loaded.
  List<Model<T>> get({List<Model<T>> orElse()}) {
    return models.maybeWhen(
      loaded: (data) => data,
      orElse: orElse,
    );
  }

  /// Shorthand to getting the model's value.
  List<Model<T>> call({List<Model<T>> orElse()}) => get(orElse: orElse);

  /// Waits for the model to finish loading and returns the loaded value of the model, or calls [onError] if an error occurred.
  Future<List<Model<T>>> complete({List<Model<T>> onError(dynamic obj)}) async {
    if (isInitial) {
      await _completer.future;
    }

    return models.when(
      initial: () => throw Exception('Model is in initial state after being loaded.'),
      loaded: (data) => data,
      error: (error) => onError(error),
    );
  }
}
