import 'package:drop_core/src/query/pagination/paginated_query_result.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

class PaginateStatesQueryRequest<E extends Entity> extends QueryRequest<E, PaginatedQueryResult<State>> {
  @override
  final Query<E> query;

  final int pageSize;

  PaginateStatesQueryRequest({required this.query, this.pageSize = 20});

  @override
  String toString() {
    return '$query | paginate';
  }

  @override
  List<Object?> get props => [query, pageSize];
}
