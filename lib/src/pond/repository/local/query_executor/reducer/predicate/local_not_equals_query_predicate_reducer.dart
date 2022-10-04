import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/not_equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class LocalNotEqualsQueryPredicateReducer
    extends AbstractQueryPredicateReducer<NotEqualsQueryPredicate, Iterable<State>> {
  @override
  Iterable<State> reduce({required Iterable<State> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final notEqualsQueryPredicate = queryPredicate as NotEqualsQueryPredicate;
    return aggregate.where((record) => _predicatePasses(notEqualsQueryPredicate, record));
  }

  bool _predicatePasses(NotEqualsQueryPredicate queryPredicate, State state) {
    final stateField = queryPredicate.stateField;
    final stateValues = state.fullValues;

    return stateValues[stateField] != queryPredicate.isNotEqualTo;
  }
}