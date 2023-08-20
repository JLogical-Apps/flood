import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';

class WithoutCacheQueryRequest<E extends Entity, T> extends QueryRequestWrapper<E, T> {
  @override
  final QueryRequest<E, T> queryRequest;

  WithoutCacheQueryRequest({required this.queryRequest});

  @override
  String toString() {
    return '$queryRequest | without cache';
  }

  @override
  List<Object?> get props => queryRequest.props + ['withoutCache'];
}
