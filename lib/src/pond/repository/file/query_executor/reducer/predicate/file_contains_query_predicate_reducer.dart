import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/contains_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class FileContainsQueryPredicateReducer
    extends AbstractQueryPredicateReducer<ContainsQueryPredicate, Iterable<State>> {
  @override
  Iterable<State> reduce({required Iterable<State> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final containsQueryPredicate = queryPredicate as ContainsQueryPredicate;
    return aggregate.where((record) => _predicatePasses(containsQueryPredicate, record));
  }

  bool _predicatePasses(ContainsQueryPredicate queryPredicate, State state) {
    final stateField = queryPredicate.stateField;
    final stateValues = state.fullValues;

    if (!stateValues.containsKey(stateField)) {
      return false;
    }

    final list = stateValues[stateField] as List?;

    if (list == null) {
      return false;
    }

    return list.contains(queryPredicate.contains);
  }
}
