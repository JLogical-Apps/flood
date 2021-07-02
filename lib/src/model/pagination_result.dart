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
}
