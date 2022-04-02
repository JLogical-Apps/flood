import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';
import 'package:rxdart/rxdart.dart';

class QueryPaginationResultController<R extends Record> {
  final BehaviorSubject<QueryPaginationResult<R>> _resultsX = BehaviorSubject();

  QueryPaginationResultController({required QueryPaginationResult<R> result}) {
    _resultsX.value = result;
  }

  late final ValueStream<List<R>> resultsX = _resultsX.mapWithValue((paginationResult) => paginationResult.results);

  List<R> get results => _resultsX.value.results;

  bool get canLoadMore => _resultsX.value.canLoadMore;

  Future<QueryPaginationResult<R>?> loadMore() async {
    if (!canLoadMore) {
      throw Exception('Cannot load more results in this query!');
    }
    final result = _resultsX.value;
    final nextResult = await result.loadMore();
    if (nextResult != null) {
      _resultsX.value = result.appendedWith(nextResult);
    } else {
      _resultsX.value = result.end();
    }
    return nextResult;
  }
}
