import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/query/derived/first_query_request.dart';
import 'package:jlogical_utils/src/pond/query/predicate/contains_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';

import '../../utils/export_core.dart';
import '../record/record.dart';
import 'derived/exists_query_request.dart';
import 'from_query.dart';
import 'order_by_query.dart';
import 'predicate/greater_than_or_equal_to_query_predicate.dart';
import 'predicate/greater_than_query_predicate.dart';
import 'predicate/less_than_or_equal_to_query_predicate.dart';
import 'predicate/less_than_query_predicate.dart';

@marker
abstract class Query<R extends Record> extends Equatable {
  static const String id = '_id';
  static const String type = '_type';

  final Query? parent;

  Query({this.parent}) {
    if (parent is WithoutCacheQuery) {
      throw Exception(
          'Cannot place `.withoutCache()` in the middle of a query! Must be placed as the last part of the query before the request itself (or after request)');
    }
  }

  /// Whether this query is necessary in [queryRequest] in order for [queryRequest] to be considered a super-query.
  bool mustBePresentInSuperQuery(QueryRequest queryRequest) {
    return false;
  }

  Type get recordType => R;

  static Query<R> from<R extends Record>() {
    return FromQuery<R>();
  }

  static FirstOrNullQueryRequest<R> getById<R extends Record>(String id) {
    return Query.from<R>().where(Query.id, isEqualTo: id).firstOrNull(orderMatters: false);
  }

  Query<R> where(
    String stateField, {
    dynamic isEqualTo,
    dynamic contains,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    bool isNull: false,
  }) {
    if (isEqualTo != null) {
      return WhereQuery(
        queryPredicate: EqualsQueryPredicate(stateField: stateField, isEqualTo: isEqualTo),
        parent: this,
      );
    }

    if (contains != null) {
      return WhereQuery(
        queryPredicate: ContainsQueryPredicate(stateField: stateField, contains: contains),
        parent: this,
      );
    }

    if (isGreaterThan != null) {
      return WhereQuery(
        queryPredicate: GreaterThanQueryPredicate(stateField: stateField, isGreaterThan: isGreaterThan),
        parent: this,
      );
    }

    if (isGreaterThanOrEqualTo != null) {
      return WhereQuery(
        queryPredicate: GreaterThanOrEqualToQueryPredicate(
          stateField: stateField,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        ),
        parent: this,
      );
    }

    if (isLessThan != null) {
      return WhereQuery(
        queryPredicate: LessThanQueryPredicate(stateField: stateField, isLessThan: isLessThan),
        parent: this,
      );
    }

    if (isLessThanOrEqualTo != null) {
      return WhereQuery(
        queryPredicate: LessThanOrEqualToQueryPredicate(
          stateField: stateField,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
        ),
        parent: this,
      );
    }

    if (isNull) {
      return WhereQuery(
        queryPredicate: EqualsQueryPredicate(stateField: stateField, isEqualTo: null),
        parent: this,
      );
    }

    throw Exception('One of the predicates must not be null!');
  }

  Query<R> withoutCache() {
    return WithoutCacheQuery(parent: this);
  }

  Query<R> orderByAscending(String fieldName) {
    return OrderByQuery(parent: this, fieldName: fieldName, orderByType: OrderByType.ascending);
  }

  Query<R> orderByDescending(String fieldName) {
    return OrderByQuery(parent: this, fieldName: fieldName, orderByType: OrderByType.descending);
  }

  AllQueryRequest<R> all() {
    return AllQueryRequest<R>(query: this);
  }

  FirstOrNullQueryRequest<R> firstOrNull({bool orderMatters: true}) {
    return FirstOrNullQueryRequest<R>(query: this, orderMatters: orderMatters);
  }

  FirstQueryRequest<R> first({FutureOr<R> orElse()?}) {
    return FirstQueryRequest(query: this, orElse: orElse);
  }

  PaginateQueryRequest<R> paginate({int limit: 20}) {
    return PaginateQueryRequest<R>(query: this, limit: limit);
  }

  ExistsQueryRequest<R> exists() {
    return ExistsQueryRequest(query: this);
  }

  /// Returns the list of queries in the query chain starting with the root and ending at this query.
  List<Query> getQueryChain() {
    var queries = <Query>[];
    Query? _query = this;
    while (_query != null) {
      queries.add(_query);
      _query = _query.parent;
    }
    return queries.reversed.toList();
  }

  @override
  List<Object?> get props => [parent, ...queryProps];

  List<Object?> get queryProps => [];

  bool equalsIgnoringCache(Query query) {
    Query thisQuery = this;
    if (this is WithoutCacheQuery) {
      thisQuery = (this as WithoutCacheQuery).parent!;
    }

    if (query is WithoutCacheQuery) {
      query = query.parent!;
    }

    return thisQuery == query;
  }
}
