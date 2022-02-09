import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/greater_than_or_equal_to_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

class FirestoreGreaterThanOrEqualToQueryPredicateReducer
    extends AbstractQueryPredicateReducer<GreaterThanOrEqualToQueryPredicate, firestore.Query> {
  @override
  firestore.Query reduce({required firestore.Query aggregate, required AbstractQueryPredicate queryPredicate}) {
    final greaterThanOrEqualToPredicate = queryPredicate as GreaterThanOrEqualToQueryPredicate;
    return aggregate.where(
      greaterThanOrEqualToPredicate.stateField,
      isGreaterThanOrEqualTo: greaterThanOrEqualToPredicate.isGreaterThanOrEqualTo,
    );
  }
}
