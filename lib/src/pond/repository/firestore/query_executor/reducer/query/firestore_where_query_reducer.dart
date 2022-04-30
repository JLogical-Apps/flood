import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/query_executor/reducer/predicate/firestore_contains_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/query_executor/reducer/predicate/firestore_equals_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/query_executor/reducer/predicate/firestore_greater_than_or_equal_to_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/query_executor/reducer/predicate/firestore_greater_than_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/query_executor/reducer/predicate/firestore_less_than_or_equal_to_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/firestore/query_executor/reducer/predicate/firestore_less_than_query_predicate_reducer.dart';

import '../../../../../../patterns/export_core.dart';

class FirestoreWhereQueryReducer extends AbstractQueryReducer<WhereQuery, firestore.Query>
    with WithWrapperResolver<AbstractQueryPredicate, AbstractQueryPredicateReducer<dynamic, firestore.Query>>
    implements Resolver<AbstractQueryPredicate, AbstractQueryPredicateReducer<dynamic, firestore.Query>> {
  late List<AbstractQueryPredicateReducer<dynamic, firestore.Query>> wrappers = [
    FirestoreEqualsQueryPredicateReducer(),
    FirestoreContainsQueryPredicateReducer(),
    FirestoreGreaterThanQueryPredicateReducer(),
    FirestoreGreaterThanOrEqualToQueryPredicateReducer(),
    FirestoreLessThanQueryPredicateReducer(),
    FirestoreLessThanOrEqualToQueryPredicateReducer(),
  ];

  @override
  Future<firestore.Query> reduce({required firestore.Query? accumulation, required Query query}) async {
    final whereQuery = query as WhereQuery;
    final queryPredicate = whereQuery.queryPredicate;

    final queryPredicateReducer = resolve(queryPredicate);
    return queryPredicateReducer.reduce(aggregate: accumulation!, queryPredicate: queryPredicate);
  }
}
