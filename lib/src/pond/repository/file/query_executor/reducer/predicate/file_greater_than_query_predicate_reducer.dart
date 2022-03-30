import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/greater_than_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class FileGreaterThanQueryPredicateReducer
    extends AbstractQueryPredicateReducer<GreaterThanQueryPredicate, Iterable<State>> {
  @override
  Iterable<State> reduce({required Iterable<State> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final greaterThanPredicate = queryPredicate as GreaterThanQueryPredicate;
    return aggregate.where((record) => _predicatePasses(greaterThanPredicate, record));
  }

  bool _predicatePasses(GreaterThanQueryPredicate queryPredicate, State state) {
    final stateField = queryPredicate.stateField;
    final stateValues = state.fullValues;

    if (!stateValues.containsKey(stateField)) {
      return false;
    }

    final stateValue = stateValues[stateField];

    var compareTo = queryPredicate.isGreaterThan;
    if (queryPredicate.isGreaterThan is DateTime) {
      compareTo = (queryPredicate.isGreaterThan as DateTime).millisecondsSinceEpoch;
    }

    return stateValue > compareTo;
  }
}
