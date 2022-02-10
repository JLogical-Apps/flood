import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/result/query_pagination_result_controller.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

import '../query.dart';

class PaginateQueryRequest<R extends Record> extends QueryRequest<R, QueryPaginationResultController<R>> {
  final Query<R> query;
  final int limit;

  PaginateQueryRequest({required this.query, this.limit: 20, Transaction? transaction})
      : super(transaction: transaction);

  @override
  List<Object?> get queryRequestProps => [limit];
}
