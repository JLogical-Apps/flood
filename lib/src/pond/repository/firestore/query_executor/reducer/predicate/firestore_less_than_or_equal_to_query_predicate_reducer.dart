import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/less_than_or_equal_to_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

class FirestoreLessThanOrEqualToQueryPredicateReducer
    extends AbstractQueryPredicateReducer<LessThanOrEqualToQueryPredicate, firestore.Query> {
  @override
  firestore.Query reduce({required firestore.Query aggregate, required AbstractQueryPredicate queryPredicate}) {
    final lessThanOrEqualToPredicate = queryPredicate as LessThanOrEqualToQueryPredicate;

    var compareTo = lessThanOrEqualToPredicate.isLessThanOrEqualTo;
    if (compareTo is DateTime) {
      compareTo = compareTo.millisecondsSinceEpoch;
    }
    return aggregate.where(lessThanOrEqualToPredicate.stateField, isLessThanOrEqualTo: compareTo);
  }
}
