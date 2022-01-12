import 'package:jlogical_utils/src/pond/query/predicate/greater_than_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

abstract class AbstractGreaterThanQueryPredicateReducer<C> extends AbstractQueryPredicateReducer<GreaterThanQueryPredicate, C> {
  const AbstractGreaterThanQueryPredicateReducer();
}
