import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/less_than_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalLessThanQueryPredicateReducer
    extends AbstractQueryPredicateReducer<LessThanQueryPredicate, Iterable<Record>> {
  @override
  Iterable<Record> reduce({required Iterable<Record> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final lessThanOrEqualToPredicate = queryPredicate as LessThanQueryPredicate;
    return aggregate.where((record) => _predicatePasses(lessThanOrEqualToPredicate, record));
  }

  bool _predicatePasses(LessThanQueryPredicate queryPredicate, Record record) {
    final stateField = queryPredicate.stateField;
    final stateValues = record.state.fullValues;

    if (!stateValues.containsKey(stateField)) {
      return false;
    }

    final stateValue = stateValues[stateField];

    var compareTo = queryPredicate.isLessThan;
    if (queryPredicate.isLessThan is DateTime) {
      compareTo = (queryPredicate.isLessThan as DateTime).millisecondsSinceEpoch;
    }

    return stateValue < compareTo;
  }
}
