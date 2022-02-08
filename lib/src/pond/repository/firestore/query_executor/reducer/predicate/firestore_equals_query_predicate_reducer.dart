import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_equals_query_predicate_reducer.dart';

class FirestoreEqualsQueryPredicateReducer extends AbstractEqualsQueryPredicateReducer<firestore.Query> {
  @override
  firestore.Query reduce({required firestore.Query aggregate, required AbstractQueryPredicate queryPredicate}) {
    final equalsQueryPredicate = queryPredicate as EqualsQueryPredicate;
    if (equalsQueryPredicate.stateField == Query.id) {
      return aggregate.where(firestore.FieldPath.documentId, isEqualTo: equalsQueryPredicate.isEqualTo);
    }

    if (equalsQueryPredicate.isEqualTo == null) {
      return aggregate.where(equalsQueryPredicate.stateField, isNull: true);
    }

    return aggregate.where(equalsQueryPredicate.stateField, isEqualTo: equalsQueryPredicate.isEqualTo);
  }
}
