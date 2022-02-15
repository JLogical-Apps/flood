import 'package:equatable/equatable.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
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
  List<Object?> get props => [transaction, query, ...queryRequestProps];

  List<Object?> get queryRequestProps => [];

  Future<T> get() {
    return AppContext.global.executeQuery(this);
  }

  QueryRequest<R, T> withoutCache() {
    return WithoutCacheQueryRequest<R, T>(queryRequest: this);
  }

  QueryRequest<R, S> map<S>(S mapper(T value)) {
    return MappedQueryRequest(queryRequest: this, mapper: mapper);
  }

  bool isWithoutCache() {
    return this is WithoutCacheQueryRequest || query.getQueryChain().any((query) => query is WithoutCacheQuery);
  }

  bool equalsIgnoringCache(QueryRequest queryRequest) {
    QueryRequest thisQueryRequest = this;
    if (this is WithoutCacheQueryRequest) {
      thisQueryRequest = (this as WithoutCacheQueryRequest).queryRequest;
    }

    if (queryRequest is WithoutCacheQueryRequest) {
      queryRequest = queryRequest.queryRequest;
    }

    return identical(thisQueryRequest, queryRequest) ||
        thisQueryRequest.runtimeType == queryRequest.runtimeType &&
            equals(queryRequestProps, queryRequest.queryRequestProps) &&
            thisQueryRequest.query.equalsIgnoringCache(queryRequest.query);
  }
}
