import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/derived/derived_query_request.dart';
import 'package:rxdart/rxdart.dart';

class FirstQueryRequest<R extends Record> extends DerivedQueryRequest<R, R> {
  @override
  final Query<R> query;

  final FutureOr<R> Function()? orElse;

  FirstQueryRequest({required this.query, this.orElse});

  @override
  Future<R> deriveQueryResult(QueryExecutor queryExecutor) async {
    final firstEntity = await queryExecutor.executeQuery(query.firstOrNull());
    return firstEntity ?? await orElse?.call() ?? (throw Exception('Cannot find a $R by query ($query)'));
  }

  @override
  ValueStream<FutureValue<R>> deriveQueryResultX(QueryExecutorX queryExecutorX) {
    return queryExecutorX.executeQueryX(query.firstOrNull()).asyncMapWithValue((maybeAnyEntity) => maybeAnyEntity
        .mapIfPresent<Future<R>>(
            (entity) async => entity ?? await orElse?.call() ?? (throw Exception('Cannot find a $R by query ($query)')))
        .get());
  }

  @override
  String toString() {
    return '$query | first';
  }
}
