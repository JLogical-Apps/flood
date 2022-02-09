import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/contains_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalContainsQueryPredicateReducer
    extends AbstractQueryPredicateReducer<ContainsQueryPredicate, Iterable<Record>> {
  @override
  Iterable<Record> reduce({required Iterable<Record> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final containsQueryPredicate = queryPredicate as ContainsQueryPredicate;
    return aggregate.where((record) => _predicatePasses(containsQueryPredicate, record));
  }

  bool _predicatePasses(ContainsQueryPredicate queryPredicate, Record record) {
    final stateField = queryPredicate.stateField;
    final stateValues = record.state.fullValues;

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
