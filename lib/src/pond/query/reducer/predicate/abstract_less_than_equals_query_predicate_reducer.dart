import 'package:jlogical_utils/src/pond/query/predicate/less_than_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

abstract class AbstractLessThanQueryPredicateReducer<C> extends AbstractQueryPredicateReducer<LessThanQueryPredicate, C> {
  const AbstractLessThanQueryPredicateReducer();
}
