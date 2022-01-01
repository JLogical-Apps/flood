import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/utils/marker.dart';

@marker
abstract class QueryRequest<R extends Record, T> extends Equatable {
  final Transaction? transaction;

  /// The query that this request makes a request on.
  Query<R> get query;

  const QueryRequest({this.transaction});

  Type get outputType => T;

  @override
  List<Object?> get props => [transaction, query];

  QueryRequest<R, T> withoutCache() {
    return WithoutCacheQueryRequest<R, T>(queryRequest: this);
  }

  bool isWithoutCache() {
    return this is WithoutCacheQueryRequest || query.getQueryChain().any((query) => query is WithoutCacheQuery);
  }
}
