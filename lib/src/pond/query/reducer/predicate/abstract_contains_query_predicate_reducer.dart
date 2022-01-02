import 'package:jlogical_utils/src/pond/query/predicate/contains_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';

abstract class AbstractContainsQueryPredicateReducer<C>
    extends AbstractQueryPredicateReducer<ContainsQueryPredicate, C> {
  const AbstractContainsQueryPredicateReducer();
}
