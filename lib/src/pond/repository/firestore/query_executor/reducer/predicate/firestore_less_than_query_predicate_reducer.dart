import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/less_than_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

class FirestoreLessThanQueryPredicateReducer
    extends AbstractQueryPredicateReducer<LessThanQueryPredicate, firestore.Query> {
  @override
  firestore.Query reduce({required firestore.Query aggregate, required AbstractQueryPredicate queryPredicate}) {
    final lessThanQueryPredicate = queryPredicate as LessThanQueryPredicate;

    var compareTo = lessThanQueryPredicate.isLessThan;
    if (compareTo is DateTime) {
      compareTo = compareTo.millisecondsSinceEpoch;
    }
    return aggregate.where(lessThanQueryPredicate.stateField, isLessThan: compareTo);
  }
}
