import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/predicate/equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/paginate_query_request.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';
import 'package:jlogical_utils/src/utils/marker.dart';

import 'from_query.dart';
import 'request/first_query_request.dart';

@marker
abstract class Query<R extends Record> extends Equatable {
  static const String id = '_id';
  static const String type = '_type';

  final Query? parent;

  const Query({this.parent});

  Type get recordType => R;

  static Query<R> from<R extends Record>() {
    return FromQuery<R>();
  }

  static FirstOrNullQueryRequest<R> getById<R extends Record>(String id) {
    return Query.from<R>().where(Query.id, isEqualTo: id).firstOrNull();
  }

  Query<R> where(String stateField, {dynamic isEqualTo}) {
    if (isEqualTo != null) {
      return WhereQuery(
        queryPredicate: EqualsQueryPredicate(stateField: stateField, isEqualTo: isEqualTo),
        parent: this,
      );
    }

    throw Exception('One of the predicates must not be null!');
  }

  AllQueryRequest<R> all() {
    return AllQueryRequest<R>(query: this);
  }

  FirstOrNullQueryRequest<R> firstOrNull() {
    return FirstOrNullQueryRequest<R>(query: this);
  }

  PaginateQueryRequest<R> paginate({int limit: 20}) {
    return PaginateQueryRequest<R>(query: this, limit: limit);
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
  List<Object?> get props => [parent];
}
