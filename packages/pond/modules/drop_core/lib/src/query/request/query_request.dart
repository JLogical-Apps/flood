import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

abstract class QueryRequest<E extends Entity, T> {
  final Query<E> query;

  QueryRequest({required this.query});
}
