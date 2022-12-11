import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/state/state.dart';

class AllStatesQueryRequest with IsQueryRequest<List<State>> {
  @override
  final Query query;

  AllStatesQueryRequest({required this.query});
}
