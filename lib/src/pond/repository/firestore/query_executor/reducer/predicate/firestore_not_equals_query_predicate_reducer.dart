import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/not_equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

class FirestoreNotEqualsQueryPredicateReducer
    extends AbstractQueryPredicateReducer<NotEqualsQueryPredicate, firestore.Query> {
  @override
  firestore.Query reduce({required firestore.Query aggregate, required AbstractQueryPredicate queryPredicate}) {
    final equalsQueryPredicate = queryPredicate as NotEqualsQueryPredicate;
    if (equalsQueryPredicate.stateField == Query.id) {
      return aggregate.where(firestore.FieldPath.documentId, isEqualTo: equalsQueryPredicate.isNotEqualTo);
    }

    if (equalsQueryPredicate.isNotEqualTo == null) {
      return aggregate.where(equalsQueryPredicate.stateField, isNull: false);
    }

    var compareTo = equalsQueryPredicate.isNotEqualTo;
    if (compareTo is DateTime) {
      compareTo = compareTo.millisecondsSinceEpoch;
    }
    return aggregate.where(equalsQueryPredicate.stateField, isNotEqualTo: compareTo);
  }
}
