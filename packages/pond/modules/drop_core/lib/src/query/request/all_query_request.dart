import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';

class AllQueryRequest<E extends Entity> extends QueryRequest<List<E>> {
  AllQueryRequest({required super.query});

  Type get entityType => E;
}
