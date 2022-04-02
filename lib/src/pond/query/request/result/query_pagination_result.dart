import 'package:jlogical_utils/src/pond/record/record.dart';

class QueryPaginationResult<R extends Record> {
  final List<R> results;

  Future<QueryPaginationResult<R>?> Function()? nextGetter;

  QueryPaginationResult({required this.results, this.nextGetter});

  bool get canLoadMore => nextGetter != null;

  Future<QueryPaginationResult<R>?> loadMore() async {
    if (!canLoadMore) {
      throw Exception('Cannot load more results in this query!');
    }
    final newPaginationResult = await nextGetter!();
    return newPaginationResult;
  }

  QueryPaginationResult<R> appendedWith(QueryPaginationResult<R> other) {
    return QueryPaginationResult(
      results: results + other.results,
      nextGetter: other.nextGetter,
    );
  }

  QueryPaginationResult<R> end() {
    return QueryPaginationResult(results: results, nextGetter: null);
  }

  static QueryPaginationResult<R> empty<R extends Record>() {
    return QueryPaginationResult(results: []);
  }

  static QueryPaginationResult<R> paginate<R extends Record>(
    List<R> records, {
    int? limit: 20,
    Future<QueryPaginationResult<R>?> postLoadNextGetter()?,
  }) {
    final canPaginate = limit != null && records.length > limit;

    Iterable<R> results = records;
    if (limit != null) {
      results = results.take(limit);
    }

    return QueryPaginationResult(
      results: results.toList(),
      nextGetter: canPaginate
          ? () async => paginate(records.skip(limit).toList(), limit: limit, postLoadNextGetter: postLoadNextGetter)
          : postLoadNextGetter,
    );
  }

  static Future<QueryPaginationResult<R>> paginateWithProcessing<R extends Record>(
    List<R> records, {
    required Future<void> onProcess(R record),
    int? limit: 20,
    Future<QueryPaginationResult<R>?> postLoadNextGetter()?,
  }) async {
    final canPaginate = limit != null && records.length > limit;

    Iterable<R> results = records;
    if (limit != null) {
      results = results.take(limit);
    }

    await Future.wait(results.map((result) => onProcess(result)));

    return QueryPaginationResult(
      results: results.toList(),
      nextGetter: canPaginate
          ? () async => paginate(records.skip(limit).toList(), limit: limit, postLoadNextGetter: postLoadNextGetter)
          : postLoadNextGetter,
    );
  }
}
