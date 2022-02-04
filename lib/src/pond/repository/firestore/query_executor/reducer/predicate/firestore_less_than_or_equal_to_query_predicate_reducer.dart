import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/less_than_or_equal_to_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_less_than_or_equal_to_equals_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class FirestoreLessThanOrEqualToQueryPredicateReducer
    extends AbstractLessThanOrEqualToQueryPredicateReducer<firestore.Query> {
  @override
  firestore.Query reduce({required firestore.Query aggregate, required AbstractQueryPredicate queryPredicate}) {
    final lessThanOrEqualToPredicate = queryPredicate as LessThanOrEqualToQueryPredicate;
    return aggregate.where((record) => _predicatePasses(lessThanOrEqualToPredicate, record));
  }

  bool _predicatePasses(LessThanOrEqualToQueryPredicate queryPredicate, Record record) {
    final stateField = queryPredicate.stateField;
    final stateValues = record.state.fullValues;

    if (!stateValues.containsKey(stateField)) {
      return false;
    }

    final stateValue = stateValues[stateField];

    var compareTo = queryPredicate.isLessThanOrEqualTo;
    if (queryPredicate.isLessThanOrEqualTo is DateTime) {
      compareTo = (queryPredicate.isLessThanOrEqualTo as DateTime).millisecondsSinceEpoch;
    }

    return stateValue <= compareTo;
  }
}