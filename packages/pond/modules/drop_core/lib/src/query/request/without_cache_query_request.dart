import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';

class WithoutCacheQueryRequest<E extends Entity, T> extends QueryRequestWrapper<E, T> {
  @override
  final QueryRequest<E, T> queryRequest;

  WithoutCacheQueryRequest({required this.queryRequest});

  @override
  String prettyPrint(DropCoreContext context) {
    return '${queryRequest.prettyPrint(context)} | without cache';
  }

  @override
  List<Object?> get props => queryRequest.props + ['withoutCache'];
}
