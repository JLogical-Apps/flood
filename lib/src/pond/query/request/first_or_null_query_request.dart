import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class FirstOrNullQueryRequest<R extends Record> extends QueryRequest<R, R?> {
  final Query<R> query;

  FirstOrNullQueryRequest({required this.query});
}
