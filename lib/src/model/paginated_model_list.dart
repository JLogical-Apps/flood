import 'dart:async';
import 'dart:collection';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/model/pagination_result.dart';
import 'package:rxdart/rxdart.dart';

import 'model.dart';

/// A model list that handles paginating the results.
/// Use [loadNextPage] to append the next page (if it exists) to the
class PaginatedModelList<T> extends Model<PaginationResult<Model<T>>> {
  /// [converter] converts values from the page loads to models.
  /// [initialPageLoader] is the loader that is called with [load].
  PaginatedModelList({required Model<T> converter(T value), required Future<PaginationResult<T>> initialPageLoader()})
      : super(
          initialValue: null,
          loader: () => _transformer(initialPageLoader, converter),
        );

  /// Stream of models of the list.
  late ValueStream<FutureValue<List<Model<T>>>> modelsX = _modelsX;
  
  ValueStream<FutureValue<List<Model<T>>>> get _modelsX {
    FutureValue<List<Model<T>>> mapper(FutureValue<PaginationResult<Model<T>>> value) => value.when(
          initial: () => FutureValue.initial(),
          loaded: (map) => FutureValue.loaded(value: map.results.values.toList()),
          error: (error) => FutureValue.error(error: error),
        );

    return subject.map(mapper).shareValueSeeded(mapper(subject.value));
  }

  /// The models of the list.
  FutureValue<List<Model<T>>> get models => modelsX.value;

  /// Stream of the results of the list.
  late ValueStream<FutureValue<List<T>>> resultsX = _resultsX;

  ValueStream<FutureValue<List<T>>> get _resultsX {
    FutureValue<List<T>> Function(FutureValue<PaginationResult<Model<T>>>) mapper = (value) => value.when(
          initial: () => FutureValue.initial(),
          loaded: (map) => FutureValue.loaded(value: map.results.values.map((model) => model.get()).toList()),
          error: (error) => FutureValue.error(error: error),
        );
    return subject.map(mapper).shareValueSeeded(mapper(subject.value));
  }

  /// The results of the list.
  FutureValue<List<T>> get results => resultsX.value;

  /// Returns the ids of the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<String> getIDs({List<String> orElse()?}) =>
      getOrNull(orElse: () => null)?.results.keys.toList() ??
      (orElse != null ? orElse() : throw Exception('getIDs() called without loaded state in ModelList!'));

  /// Returns the ids of the loaded value of the model, or calls [orElse] if [orElse] is not null, or returns [null].
  List<String>? getIDsOrNull({List<String>? orElse()?}) => getOrNull(orElse: () => null)?.results.keys.toList() ?? orElse?.call();

  /// Returns the models of the loaded value of the model, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<Model<T>> getModels({List<Model<T>> orElse()?}) =>
      getOrNull(orElse: () => null)?.results.values.toList() ??
      (orElse != null ? orElse() : throw Exception('getModels() called without loaded state in PaginatedModelList!'));

  /// Returns the models of the loaded value of the model, or calls [orElse] if [orElse] is not null, or returns [null].
  List<Model<T>>? getModelsOrNull({List<Model<T>>? orElse()?}) => getOrNull(orElse: () => null)?.results.values.toList() ?? orElse?.call();

  /// Returns the results of the loaded pages, or calls [orElse] if not loaded.
  /// Throws an exception if not loaded and [orElse] is null.
  List<T> getResults({List<T> orElse()?}) =>
      getModelsOrNull()?.map((model) => model.get()).toList() ??
      (orElse != null ? orElse() : throw Exception('getResults() called without loaded state in PaginatedModelList!'));

  /// Returns the results of the page, or calls [orElse] if [orElse] is not null, or returns [null].
  List<T>? getResultsOrNull({List<T>? orElse()?}) => getModelsOrNull()?.map((model) => model.get()).toList() ?? orElse?.call();

  /// Transforms the pagination results to ones with models.
  static FutureOr<PaginationResult<Model<T>>> _transformer<T>(FutureOr<PaginationResult<T>> loader(), Model<T> converter(T value)) async {
    var page = await loader();
    return PaginationResult(
        results: page.results.map((key, value) => MapEntry(
              key,
              converter(value),
            )),
        nextPageGetter: page.hasNextPage ? (() => _transformer(page.nextPageGetter!, converter)) : null);
  }

  /// Loads the next page of data.
  Future<void> loadNextPage() {
    return value.when(
        initial: () async => print('Invalid initial state for loading next page.'),
        error: (error) async => print('Invalid error state for loading next page.'),
        loaded: (value) async {
          var newResult = await value.attachWithNextPageResults();
          setLoaded(newResult);
        });
  }

  /// Adds a model to the list if it is loaded.
  /// Throws an exception if not loaded.
  void addModel(String id, Model<T> model) {
    var page = get();
    var results = LinkedHashMap.of(page.results)..addAll({id: model});
    page = PaginationResult(
      results: results,
      nextPageGetter: page.nextPageGetter,
    );
    setLoaded(page);
  }

  /// Adds all the models to the list.
  void addAllModels(Map<String, Model<T>> models) {
    var page = get();
    var results = LinkedHashMap.of(page.results)..addAll(models);
    page = PaginationResult(
      results: results,
      nextPageGetter: page.nextPageGetter,
    );
    setLoaded(page);
  }

  /// Removes the model with the given [id].
  /// Throws an exception if not loaded.
  void removeModel(String id) {
    var page = get();

    var results = LinkedHashMap.of(page.results);
    results.remove(id);

    page = PaginationResult(
      results: results,
      nextPageGetter: page.nextPageGetter,
    );
    setLoaded(page);
  }

  /// Sets the model with the [id] to [model].
  /// Throws an exception if not loaded.
  void setModel(String id, Model<T> model) {
    var page = get();

    var results = LinkedHashMap.of(page.results);
    results[id] = model;

    page = PaginationResult(
      results: results,
      nextPageGetter: page.nextPageGetter,
    );

    setLoaded(page);
  }
}
