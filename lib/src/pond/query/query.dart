import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/predicate/equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';
import 'package:jlogical_utils/src/utils/marker.dart';

import 'all_query.dart';
import 'from_query.dart';

@marker
abstract class Query<R extends Record> {
  final Query? parent;

  const Query({this.parent});

  Type get recordType => R;

  static Query fromAll() {
    return AllQuery();
  }

  static Query<R> from<R extends Record>() {
    return FromQuery<R>();
  }

  Query<R> where<R extends Record>(String stateField, {dynamic isEqualTo}) {
    if (isEqualTo != null) {
      return WhereQuery(
        queryPredicate: EqualsQueryPredicate(stateField: stateField, isEqualTo: isEqualTo),
        parent: this,
      );
    }

    throw Exception('One of the predicates must not be null!');
  }

  QueryRequest<R, List<R>> all() {
    return AllQueryRequest<R>(query: this);
  }
}
