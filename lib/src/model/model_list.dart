import 'dart:async';

import 'package:jlogical_utils/src/persistence/export_core.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import 'future_value.dart';
import 'model.dart';

/// Manages a list of models that can be reloaded.
class ModelList<T> extends Model<Map<String, Model<T>>> {
  // Converts the list elements to models.
  final Model<T> Function(T value) converter;

  /// If not null, can automatically generate ids for models that are added to this list.
  final IdGenerator<T, String>? idGenerator;

  /// [loader] loads the raw list result.
  /// [initialValues] are optional values to have initially.
  /// [initialData] can be used to prepopulate the list by calling [idGenerator] to get ids and [converter] to convert to models.
  ModelList({
    required Future<Map<String, T>> loader(),
    required this.converter,
    this.idGenerator,
    Map<String, Model<T>>? initialValues,
    List<T>? initialData,
  }) : super(
            initialValue: initialValues,
            loader: () async {
              var rawResults = await loader();
              return rawResults.map((key, value) => MapEntry(key, converter(value)));
            }) {
    if (initialData != null) addAllData(initialData);
  }

  /// Stream of ids of the list.
  late ValueStream<FutureValue<List<String>>> idsX = subject.mapWithValue((value) => value.when(
        initial: () => FutureValue.initial(),
        loaded: (map) => FutureValue.loaded(value: map.keys.toList()),
        error: (error) => FutureValue.error(error: error),
      ));

  /// The ids of the list.
  FutureValue<List<String>> get ids => idsX.value;

  /// Stream of models of the list.
  late ValueStream<FutureValue<List<Model<T>>>> modelsX = subject.mapWithValue((value) => value.when(
        initial: () => FutureValue.initial(),
        loaded: (map) => FutureValue.loaded(value: map.values.toList()),
        error: (error) => FutureValue.error(error: error),
      ));

  /// The models of the list.
  FutureValue<List<Model<T>>> get models => modelsX.value;

  /// Returns the ids of the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<String> getIDs({List<String> orElse()?}) =>
      getOrNull(orElse: () => null)?.keys.toList() ??
      (orElse != null ? orElse() : throw Exception('getIDs() called without loaded state in ModelList!'));

  /// Returns the ids of the loaded value of the model, or calls [orElse] if [orElse] is not null, or returns [null].
  List<String>? getIDsOrNull({List<String>? orElse()?}) =>
      getOrNull(orElse: () => null)?.keys.toList() ?? orElse?.call();

  /// Returns the models of the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<Model<T>> getModels({List<Model<T>> orElse()?}) =>
      getOrNull(orElse: () => null)?.values.toList() ??
      (orElse != null ? orElse() : throw Exception('getModels() called without loaded state in ModelList!'));

  /// Returns the models of the loaded value of the model, or calls [orElse] if [orElse] is not null, or returns [null].
  List<Model<T>>? getModelsOrNull({List<Model<T>>? orElse()?}) =>
      getOrNull(orElse: () => null)?.values.toList() ?? orElse?.call();

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

  /// Adds a model to the beginning of the list if it is loaded.
  /// Throws an exception if not loaded.
  void addModelToBeginning(String id, Model<T> model) {
    var page = get();
    var models = {
      ...{id: model},
      ...page,
    };
    setLoaded(models);
  }

  /// Adds a [data] with an auto-generated id from [idGenerator] and converted to a Model with [converter].
  /// Returns the generated id.
  String addData(T data) {
    if (idGenerator == null) throw Exception('Cannot add data to a ModelList without an idGenerator!');

    var model = converter(data);
    var id = idGenerator!.getId(data);

    addModel(id, model);
    return id;
  }

  /// Adds a [data] with an auto-generated id from [idGenerator] and converted to a Model with [converter] at the
  /// beginning of the list if it is loaded.
  /// Returns the generated id.
  String addDataToBeginning(T data) {
    if (idGenerator == null) throw Exception('Cannot add data to a PaginatedModelList without an idGenerator!');

    var model = converter(data);
    var id = idGenerator!.getId(data);

    addModelToBeginning(id, model);
    return id;
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

  /// Adds all the [data] elements with auto-generated ids from [idGenerator] and converted to Models using [converter].
  void addAllData(List<T> data) {
    if (idGenerator == null) throw Exception('Cannot add data to a ModelList without an idGenerator!');

    var models = data.map(converter).toList();
    var ids = data.map(idGenerator!.getId).toList();

    addAllModels(Map.fromIterables(ids, models));
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
