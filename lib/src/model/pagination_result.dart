import 'dart:async';

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
      results: {...results, ...nextPage.results},
      nextPageGetter: nextPage.nextPageGetter,
    );
  }
}

/*


==transactions_repository
Future<PaginationResult<Transaction>> getAllTransactions()

Future<PaginationResult<Transaction>> _getTransactions({DocumentSnapshot lastDoc}) async {
  var results = await firebase.get(lastDoc);
  return PaginationResult(results: results, nextPage: () => _getTransactions(results.lastDoc));
}

==transactions_store
late PaginatedModelList<Transaction> transactions = PaginatedListModel(
  initial_pagination: () async {
    var pagination = await repo.getAllTransactions();
    return pagination;
  },
  converter: (id, entity) => get(...);
)..load();

Future<void> loadMore() async {
  await pagination.when(
    initial: () => load(),
    error: () => ...,
    loaded: (pagination) async {
      var currResults = pagination.results;
      var newResults = await pagination.getNextResults();
      value = loaded({...currResults, ...newResults});
    }
  );
}

==transactions_page
Observer(
  builder: (context) => transactionsStore.getTransactions().modelsMap.when(
    initial: () => ...
    error: () => ...
    loaded: (transactions) => Column(
      children: [
        ...transactions,
        LoadMoreButton(transactionsStore.getTransactions()),
      ]
    )
  ),
)


 */
