import 'package:jlogical_utils/src/pond/record/record.dart';

class QueryPaginationResult<R extends Record> {
  final List<R> results;

  Future<QueryPaginationResult<R>> Function()? nextGetter;

  QueryPaginationResult._({required this.results, this.nextGetter});

  bool get canLoadMore => nextGetter != null;

  Future<QueryPaginationResult<R>> loadMore() async {
    if (!canLoadMore) {
      throw Exception('Cannot load more results in this query!');
    }
    final newPaginationResult = await nextGetter!();
    return appendedWith(newPaginationResult);
  }

  QueryPaginationResult<R> appendedWith(QueryPaginationResult<R> other) {
    return QueryPaginationResult._(
      results: results + other.results,
      nextGetter: other.nextGetter,
    );
  }

  static QueryPaginationResult<R> paginate<R extends Record>(List<R> records, {int limit: 20}) {
    final canPaginate = records.length > limit;

    return QueryPaginationResult._(
      results: records.take(limit).toList(),
      nextGetter: canPaginate ? () async => paginate(records.skip(limit).toList(), limit: limit) : null,
    );
  }
}
