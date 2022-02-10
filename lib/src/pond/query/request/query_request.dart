import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/utils/marker.dart';

import '../query.dart';

@marker
abstract class QueryRequest<R extends Record, T> extends Equatable {
  final Transaction? transaction;

  /// The query that this request makes a request on.
  Query<R> get query;

  const QueryRequest({this.transaction});

  @override
  List<Object?> get props => [transaction, query];

  Future<T> get() {
    return AppContext.global.executeQuery(this);
  }

  QueryRequest<R, T> withoutCache() {
    return WithoutCacheQueryRequest<R, T>(queryRequest: this);
  }

  bool isWithoutCache() {
    return this is WithoutCacheQueryRequest || query.getQueryChain().any((query) => query is WithoutCacheQuery);
  }
}
