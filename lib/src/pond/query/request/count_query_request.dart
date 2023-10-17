import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class CountQueryRequest<R extends Record> extends QueryRequest<R, int> {
  final Query<R> query;

  CountQueryRequest({required this.query});

  bool isSupertypeOf(QueryRequest queryRequest) {
    return true;
  }

  @override
  String toString() {
    return '$query | count';
  }
}
