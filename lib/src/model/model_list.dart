import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:mobx/mobx.dart';

part 'model_list.g.dart';

class ModelList<T> = ModelListBase<T> with _$ModelList<T>;

abstract class ModelListBase<T> with Store {
  /// The ids and models in the list.
  @observable
  FutureValue<Map<String, Model<T>>> modelsMap;

  /// A function that loads data to be stored in the model.
  FutureOr<Map<String, T>> Function() loader;

  /// Completer so that multiple [load] calls will wait for the initial [load] to complete.
  Completer _completer;

  /// Passed in converter that converts entities with ids into a model.
  Model<T> Function(String id, T entity) converter;

  /// Whether the model is in its initial state.
  bool get isInitial => modelsMap is FutureValueInitial;

  /// Whether the model is loaded.
  bool get isLoaded => modelsMap is FutureValueLoaded;

  /// Whether the model contains an error.
  bool get isError => modelsMap is FutureValueError;

  ModelListBase({this.loader, this.converter, Map<String, Model<T>> initialModels}) : modelsMap = initialModels == null ? FutureValue.initial() : FutureValue.loaded(value: initialModels);

  /// Loads the models using the loader.
  @action
  Future<void> load() async {
    // If the model is currently loading something, just wait for the previous load to finish.
    if (_completer != null && !_completer.isCompleted) {
      return await _completer.future;
    }

    _completer = Completer();

    if (modelsMap is FutureValueError) {
      modelsMap = FutureValue.initial();
    }

    modelsMap = await FutureValue.guard(() async {
      var _models = await loader();
      return _models.map((id, entity) => MapEntry(id, converter(id, entity)));
    });

    // Once the model completes loading, notify other [load] calls that the load has finished.
    _completer.complete();
    _completer = null;
  }

  /// Returns the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  Map<String, Model<T>> get({Map<String, Model<T>> orElse()}) => modelsMap.maybeWhen(
        loaded: (data) => data,
        orElse: () => orElse != null ? orElse() : throw Exception('get() called without loaded state in ModelList!'),
      );

  /// Returns the ids of the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<String> getIDs({List<String> orElse()}) => get(orElse: () => null)?.keys?.toList() ?? orElse != null ? orElse() : throw Exception('getIDs() called without loaded state in ModelList!');

  /// Returns the models of the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<Model<T>> getModels({List<Model<T>> orElse()}) =>
      get(orElse: () => null)?.keys?.toList() ?? orElse != null ? orElse() : throw Exception('getModels() called without loaded state in ModelList!');

  /// Shorthand to getting the model's value.
  Map<String, Model<T>> call({Map<String, Model<T>> orElse()}) => get(orElse: orElse);

  /// Waits for the model to finish loading and returns the loaded value of the model, or calls [onError] if an error occurred.
  Future<Map<String, Model<T>>> complete({Map<String, Model<T>> onError(dynamic obj)}) async {
    if (isInitial) {
      await _completer.future;
    }

    return modelsMap.when(
      initial: () => throw Exception('Model is in initial state after being loaded.'),
      loaded: (data) => data,
      error: (error) => onError(error),
    );
  }
}
