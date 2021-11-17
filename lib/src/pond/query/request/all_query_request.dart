import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class AllQueryRequest<R extends Record> extends AbstractQueryRequest<R, List<R>> {
  AllQueryRequest({required Query<R> query}) : super(query: query);
}
