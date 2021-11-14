import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class AllQueryRequest<R extends Record> extends QueryRequest<R, List<R>> {
  AllQueryRequest({required Query<R> query}) : super(query: query);
}
