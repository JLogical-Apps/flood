import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/greater_than_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

class FirestoreGreaterThanQueryPredicateReducer
    extends AbstractQueryPredicateReducer<GreaterThanQueryPredicate, firestore.Query> {
  @override
  firestore.Query reduce({required firestore.Query aggregate, required AbstractQueryPredicate queryPredicate}) {
    final greaterThanPredicate = queryPredicate as GreaterThanQueryPredicate;
    return aggregate.where(greaterThanPredicate.stateField, isGreaterThan: greaterThanPredicate.isGreaterThan);
  }
}
