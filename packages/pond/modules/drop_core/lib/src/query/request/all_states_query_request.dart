import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

class AllStatesQueryRequest<E extends Entity> extends QueryRequest<E, List<State>> {
  AllStatesQueryRequest({required super.query});
}
