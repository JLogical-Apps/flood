import 'package:drop_core/src/query/query.dart';

abstract class QueryRequest<T> {
  final Query query;

  QueryRequest({required this.query});
}
