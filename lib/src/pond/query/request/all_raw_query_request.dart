import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class AllRawQueryRequest<R extends Record> extends QueryRequest<R, List<State>> {
  final Query<R> query;

  AllRawQueryRequest({required this.query});

  bool isSupertypeOf(QueryRequest queryRequest) {
    return false;
  }

  @override
  String toString() {
    return '$query | all.raw';
  }
}
