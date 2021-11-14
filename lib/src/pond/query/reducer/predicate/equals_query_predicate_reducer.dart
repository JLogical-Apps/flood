import 'package:jlogical_utils/src/pond/query/predicate/equals_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/query_predicate_reducer.dart';

abstract class EqualsQueryPredicateReducer<C> extends QueryPredicateReducer<EqualsQueryPredicate, C> {
  const EqualsQueryPredicateReducer();
}
