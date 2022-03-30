import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/less_than_or_equal_to_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class LocalLessThanOrEqualToQueryPredicateReducer
    extends AbstractQueryPredicateReducer<LessThanOrEqualToQueryPredicate, Iterable<State>> {
  @override
  Iterable<State> reduce({required Iterable<State> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final lessThanOrEqualToPredicate = queryPredicate as LessThanOrEqualToQueryPredicate;
    return aggregate.where((record) => _predicatePasses(lessThanOrEqualToPredicate, record));
  }

  bool _predicatePasses(LessThanOrEqualToQueryPredicate queryPredicate, State state) {
    final stateField = queryPredicate.stateField;
    final stateValues = state.fullValues;

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
