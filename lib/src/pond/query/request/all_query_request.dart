import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/all_raw_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class AllQueryRequest<R extends Record> extends QueryRequest<R, List<R>> {
  final Query<R> query;

  AllQueryRequest({required this.query});

  bool isSupertypeOf(QueryRequest queryRequest) {
    return true;
  }

  @override
  String toString() {
    return '$query | all';
  }

  AllRawQueryRequest<R> raw() {
    return AllRawQueryRequest(query: query);
  }
}