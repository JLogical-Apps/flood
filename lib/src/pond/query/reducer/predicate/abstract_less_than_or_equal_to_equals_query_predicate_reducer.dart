import 'package:jlogical_utils/src/pond/query/predicate/less_than_or_equal_to_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

abstract class AbstractLessThanOrEqualToQueryPredicateReducer<C> extends AbstractQueryPredicateReducer<LessThanOrEqualToQueryPredicate, C> {
  const AbstractLessThanOrEqualToQueryPredicateReducer();
}
