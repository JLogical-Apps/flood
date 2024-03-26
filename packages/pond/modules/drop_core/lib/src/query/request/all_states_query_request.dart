import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

class AllStatesQueryRequest<E extends Entity> extends QueryRequest<E, List<State>> {
  @override
  final Query<E> query;

  AllStatesQueryRequest({required this.query});

  @override
  String prettyPrint(DropCoreContext context) {
    return '${query.prettyPrint(context)} | all';
  }

  @override
  List<Object?> get props => [query];

  @override
  QueryRequest<E, List<State>> copyWith({Query<E>? query}) {
    return AllStatesQueryRequest(query: query ?? this.query);
  }
}
