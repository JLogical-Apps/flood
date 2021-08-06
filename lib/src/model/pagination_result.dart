import 'dart:async';
import 'dart:collection';

/// A result that contains pagination results.
class PaginationResult<T> {
  /// The results mapped to their id.
  final Map<String, T> results;

  /// Dynamic getter for the next page.
  /// Null if there is no next page.
  final FutureOr<PaginationResult<T>> Function()? nextPageGetter;

  /// Whether another page exists.
  bool get hasNextPage => nextPageGetter != null;

  const PaginationResult({required this.results, required this.nextPageGetter});

  /// Returns the results of the next page.
  Future<PaginationResult<T>> getNextPageResults() async {
    var _nextPageGetter = nextPageGetter;
    if (_nextPageGetter == null) throw Exception('No more pages to get results from');

    return await _nextPageGetter();
  }

  /// Gets the next page, and returns a new PaginationResult that combines this one with the new one.
  Future<PaginationResult<T>> attachWithNextPageResults() async {
    var _nextPageGetter = nextPageGetter;
    if (_nextPageGetter == null) throw Exception('No more pages to get results from');

    var nextPage = await _nextPageGetter();
    return PaginationResult(
      results: LinkedHashMap.of(results)..addAll(nextPage.results),
      nextPageGetter: nextPage.nextPageGetter,
    );
  }

  /// Collects the results from this page and all other pages into one map.
  /// Warning, this might take a while if there are many upcoming pages.
  Future<Map<String, T>> collectAllResults() async {
    var results = this.results;
    var nextPageGetter = this.nextPageGetter;

    while (nextPageGetter != null) {
      final nextPage = await nextPageGetter();

      results = {
        ...results,
        ...nextPage.results,
      };

      nextPageGetter = nextPage.nextPageGetter;
    }

    return results;
  }

  /// Maps the pagination result to another type.
  PaginationResult<R> map<R>({String idMapper(String value)?, required R valueMapper(T value)}) {
    return PaginationResult(
        results: results.map((key, value) => MapEntry(idMapper == null ? key : idMapper(key), valueMapper(value))),
        nextPageGetter: nextPageGetter == null
            ? null
            : () async {
                var nextPage = await nextPageGetter!.call();
                return nextPage.map(idMapper: idMapper, valueMapper: valueMapper);
              });
  }
}
