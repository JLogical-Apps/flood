import 'package:jlogical_utils/src/pond/query/predicate/equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

abstract class AbstractEqualsQueryPredicateReducer<C> extends AbstractQueryPredicateReducer<EqualsQueryPredicate, C> {
  const AbstractEqualsQueryPredicateReducer();
}
