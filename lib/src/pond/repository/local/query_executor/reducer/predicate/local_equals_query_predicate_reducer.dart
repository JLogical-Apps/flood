import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalEqualsQueryPredicateReducer extends AbstractQueryPredicateReducer<EqualsQueryPredicate, Iterable<Record>> {
  @override
  Iterable<Record> reduce({required Iterable<Record> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final equalsQueryPredicate = queryPredicate as EqualsQueryPredicate;
    return aggregate.where((record) => _predicatePasses(equalsQueryPredicate, record));
  }

  bool _predicatePasses(EqualsQueryPredicate queryPredicate, Record record) {
    final stateField = queryPredicate.stateField;
    final stateValues = record.state.fullValues;

    return stateValues[stateField] == queryPredicate.isEqualTo;
  }
}
