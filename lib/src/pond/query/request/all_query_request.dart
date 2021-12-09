import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

class AllQueryRequest<R extends Record> extends AbstractQueryRequest<R, List<R>> {
  final Query<R> query;

  AllQueryRequest({required this.query, Transaction? transaction}) : super(transaction: transaction);
}
