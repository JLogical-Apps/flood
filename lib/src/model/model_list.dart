import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

/// Manages a list of models that can be reloaded.
class ModelList<T> extends Model<Map<String, Model<T>>> {
  /// [loader] loads the raw list result.
  /// [converter] converts the list elements to models.
  /// [initialValues] are optional values to have initially.
  ModelList({
    required Future<Map<String, T>> loader(),
    required Model<T> converter(T value),
    Map<String, Model<T>>? initialValues,
  }) : super(
            initialValue: initialValues,
            loader: () async {
              var rawResults = await loader();
              return rawResults.map((key, value) => MapEntry(key, converter(value)));
            });

  /// Stream of ids of the list.
  ValueStream<FutureValue<List<String>>> get idsX => subject.map(
        (value) => value.when(
          initial: () => FutureValue.initial(),
          loaded: (map) => FutureValue.loaded(value: map.keys.toList()),
          error: (error) => FutureValue.error(error: error),
        ),
      );

  /// The ids of the list.
  FutureValue<List<String>> get ids => idsX.value;

  /// Stream of models of the list.
  ValueStream<FutureValue<List<Model<T>>>> get modelsX => subject.map(
        (value) => value.when(
          initial: () => FutureValue.initial(),
          loaded: (map) => FutureValue.loaded(value: map.values.toList()),
          error: (error) => FutureValue.error(error: error),
        ),
      );

  /// The models of the list.
  FutureValue<List<Model<T>>> get models => modelsX.value;

  /// Returns the ids of the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<String> getIDs({List<String> orElse()?}) => getOrNull(orElse: () => null)?.keys.toList() ?? (orElse != null ? orElse() : throw Exception('getIDs() called without loaded state in ModelList!'));

  /// Returns the ids of the loaded value of the model, or calls [orElse] if [orElse] is not null, or returns [null].
  List<String>? getIDsOrNull({List<String>? orElse()?}) => getOrNull(orElse: () => null)?.keys.toList() ?? orElse?.call();

  /// Returns the models of the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<Model<T>> getModels({List<Model<T>> orElse()?}) =>
      getOrNull(orElse: () => null)?.values.toList() ?? (orElse != null ? orElse() : throw Exception('getModels() called without loaded state in ModelList!'));

  /// Returns the models of the loaded value of the model, or calls [orElse] if [orElse] is not null, or returns [null].
  List<Model<T>>? getModelsOrNull({List<Model<T>>? orElse()?}) => getOrNull(orElse: () => null)?.values.toList() ?? orElse?.call();

  /// Adds a model to the list if it is loaded.
  /// Throws an exception if not loaded.
  void addModel(String id, Model<T> model) {
    var models = get();
    models = {
      ...models,
      ...{id: model}
    };
    setLoaded(models);
  }

  /// Adds all the models to the list.
  void addAllModels(Map<String, Model<T>> models) {
    var _models = get();
    _models = {
      ..._models,
      ...models,
    };
    setLoaded(_models);
  }

  /// Removes the model with the given [id].
  /// Throws an exception if not loaded.
  void removeModel(String id) {
    var models = get();
    models = Map.of(models);
    models.remove(id);
    setLoaded(models);
  }

  /// Sets the model with the [id] to [model].
  /// Throws an exception if not loaded.
  void setModel(String id, Model<T> model) {
    var models = get();
    models = Map.of(models);
    models[id] = model;
    setLoaded(models);
  }
}
