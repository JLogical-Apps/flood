import 'package:equatable/equatable.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';
import 'package:jlogical_utils/src/utils/marker.dart';

@marker
abstract class QueryRequest<R extends Record, T> extends Equatable {
  /// The query that this request makes a request on.
  Query<R> get query;

  @override
  List<Object?> get props => [query, ...queryRequestProps];

  List<Object?> get queryRequestProps => [];

  bool isSupertypeOf(QueryRequest queryRequest) {
    return false;
  }

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

  bool containsOrEquals(QueryRequest queryRequest) {
    if (equalsIgnoringCache(queryRequest)) {
      return true;
    }

    QueryRequest thisQueryRequest = this;
    if (this is WithoutCacheQueryRequest) {
      thisQueryRequest = (this as WithoutCacheQueryRequest).queryRequest;
    }

    if (queryRequest is WithoutCacheQueryRequest) {
      queryRequest = queryRequest.queryRequest;
    }

    final compatibleQueryRequestType =
        thisQueryRequest.runtimeType == queryRequest.runtimeType || thisQueryRequest.isSupertypeOf(queryRequest);
    if (!compatibleQueryRequestType) {
      return false;
    }

    final thisQueryChain = thisQueryRequest.query.getQueryChain();
    final otherQueryChain = queryRequest.query.getQueryChain();

    final compatibleQueries = thisQueryChain
        .every((thisQuery) => otherQueryChain.any((query) => equals(thisQuery.queryProps, query.queryProps)));
    if (!compatibleQueries) {
      return false;
    }

    final anyMissingQueries = otherQueryChain.any((query) =>
        query.mustBePresentInSuperQuery(thisQueryRequest) &&
        !thisQueryChain.any((thisQuery) => equals(thisQuery.queryProps, query.queryProps)));
    if (anyMissingQueries) {
      return false;
    }

    return true;
  }
}
