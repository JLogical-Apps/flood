import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

class FirstOrNullQueryRequest<R extends Record> extends AbstractQueryRequest<R, R?> {
  final Query<R> query;

  FirstOrNullQueryRequest({required this.query, Transaction? transaction}) : super(transaction: transaction);
}
