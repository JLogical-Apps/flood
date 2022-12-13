import 'package:drop_core/src/query/pagination/query_result_page.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/state/state.dart';

class PaginateStatesQueryRequest with IsQueryRequest<QueryResultPage<State>> {
  @override
  final Query query;

  final int pageSize;

  PaginateStatesQueryRequest({required this.query, this.pageSize = 20});
}
