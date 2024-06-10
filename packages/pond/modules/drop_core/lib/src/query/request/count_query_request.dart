import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';

class CountQueryRequest<E extends Entity> extends QueryRequest<E, int> {
  @override
  final Query<E> query;

  CountQueryRequest({required this.query});

  @override
  String prettyPrint(DropCoreContext context) {
    return '${query.prettyPrint(context)} | count';
  }

  @override
  List<Object?> get props => [query];

  @override
  QueryRequest<E, int> copyWith({Query<E>? query}) {
    return CountQueryRequest(query: query ?? this.query);
  }
}
