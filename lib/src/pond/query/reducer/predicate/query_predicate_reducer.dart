import 'package:jlogical_utils/src/pond/query/predicate/query_predicate.dart';

abstract class QueryPredicateReducer<P extends QueryPredicate, C> {
  const QueryPredicateReducer();

  bool shouldReduce(QueryPredicate queryPredicate) => queryPredicate is P;

  C reduce({required C aggregate, required QueryPredicate queryPredicate});
}