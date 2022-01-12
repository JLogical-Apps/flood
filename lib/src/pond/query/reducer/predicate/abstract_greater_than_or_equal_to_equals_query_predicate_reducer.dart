import 'package:jlogical_utils/src/pond/query/predicate/greater_than_or_equal_to_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

abstract class AbstractGreaterThanOrEqualToQueryPredicateReducer<C> extends AbstractQueryPredicateReducer<GreaterThanOrEqualToQueryPredicate, C> {
  const AbstractGreaterThanOrEqualToQueryPredicateReducer();
}
