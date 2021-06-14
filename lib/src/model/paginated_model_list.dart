import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/model/pagination_result.dart';

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
          this.value = FutureValue.loaded(value: newResult);
        });
  }
}
