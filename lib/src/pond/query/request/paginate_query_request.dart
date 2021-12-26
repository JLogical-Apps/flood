import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/query_pagination_result.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

import '../query.dart';

class PaginateQueryRequest<R extends Record> extends AbstractQueryRequest<R, QueryPaginationResult<R>> {
  final Query<R> query;
  final int limit;

  PaginateQueryRequest({required this.query, this.limit: 20, Transaction? transaction})
      : super(transaction: transaction);
}
