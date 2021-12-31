import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

class WithoutCacheQueryRequest<R extends Record, T> extends AbstractQueryRequest<R, T> {
  final AbstractQueryRequest<R, T> queryRequest;

  WithoutCacheQueryRequest({required this.queryRequest, Transaction? transaction}) : super(transaction: transaction);

  @override
  Query<R> get query => queryRequest.query;
}
