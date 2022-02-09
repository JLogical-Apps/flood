import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/contains_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

class FirestoreContainsQueryPredicateReducer
    extends AbstractQueryPredicateReducer<ContainsQueryPredicate, firestore.Query> {
  @override
  firestore.Query reduce({required firestore.Query aggregate, required AbstractQueryPredicate queryPredicate}) {
    final containsQueryPredicate = queryPredicate as ContainsQueryPredicate;
    return aggregate.where(containsQueryPredicate.stateField, arrayContains: queryPredicate.contains);
  }
}
