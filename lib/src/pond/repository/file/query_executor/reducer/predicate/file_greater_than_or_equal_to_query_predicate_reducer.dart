import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/predicate/greater_than_or_equal_to_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_greater_than_or_equal_to_equals_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class FileGreaterThanOrEqualToQueryPredicateReducer
    extends AbstractGreaterThanOrEqualToQueryPredicateReducer<Iterable<Record>> {
  @override
  Iterable<Record> reduce({required Iterable<Record> aggregate, required AbstractQueryPredicate queryPredicate}) {
    final greaterThanOrEqualToPredicate = queryPredicate as GreaterThanOrEqualToQueryPredicate;
    return aggregate.where((record) => _predicatePasses(greaterThanOrEqualToPredicate, record));
  }

  bool _predicatePasses(GreaterThanOrEqualToQueryPredicate queryPredicate, Record record) {
    final stateField = queryPredicate.stateField;
    final stateValues = record.state.fullValues;

    if (!stateValues.containsKey(stateField)) {
      return false;
    }

    final stateValue = stateValues[stateField];

    var compareTo = queryPredicate.isGreaterThanOrEqualTo;
    if(queryPredicate.isGreaterThanOrEqualTo is DateTime) {
      compareTo = (queryPredicate.isGreaterThanOrEqualTo as DateTime).millisecondsSinceEpoch;
    }

    return stateValue >= compareTo;
  }
}
