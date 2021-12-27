import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';
import 'package:rxdart/rxdart.dart';

class QueryPaginationResultController<R extends Record> {
  final BehaviorSubject<QueryPaginationResult<R>> _resultsX = BehaviorSubject();

  QueryPaginationResultController({required QueryPaginationResult<R> result}) {
    _resultsX.value = result;
  }

  ValueStream<List<R>> get resultsX => _resultsX.mapWithValue((paginationResult) => paginationResult.results);

  List<R> get results => _resultsX.value.results;

  bool get canLoadMore => _resultsX.value.canLoadMore;

  Future<void> loadMore() async {
    if (!canLoadMore) {
      throw Exception('Cannot load more results in this query!');
    }
    _resultsX.value = await _resultsX.value.loadMore();
  }
}
