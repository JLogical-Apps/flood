import 'package:jlogical_utils/src/patterns/wrapper/with_subtype_wrapper.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';
import 'package:jlogical_utils/src/pond/query/predicate/query_predicate.dart';

abstract class AbstractQueryPredicateReducer<P extends QueryPredicate, C>
    with WithSubtypeWrapper<P, QueryPredicate>
    implements Wrapper<QueryPredicate> {
  const AbstractQueryPredicateReducer();

  C reduce({required C aggregate, required QueryPredicate queryPredicate});
}
