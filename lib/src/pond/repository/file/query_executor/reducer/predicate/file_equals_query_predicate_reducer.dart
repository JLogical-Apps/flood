import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class FileEqualsQueryPredicateReducer extends AbstractQueryPredicateReducer<EqualsQueryPredicate, Iterable<State>> {
  @override
  Iterable<State> reduce({required Iterable<State> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final equalsQueryPredicate = queryPredicate as EqualsQueryPredicate;
    return aggregate.where((record) => _predicatePasses(equalsQueryPredicate, record));
  }

  bool _predicatePasses(EqualsQueryPredicate queryPredicate, State state) {
    final stateField = queryPredicate.stateField;
    final stateValues = state.fullValues;

    return stateValues[stateField] == queryPredicate.isEqualTo;
  }
}
